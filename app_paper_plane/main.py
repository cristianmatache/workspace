import json
import time
from argparse import ArgumentParser
from dataclasses import dataclass, field
from threading import Thread
from typing import Any, Optional, Dict, Callable, cast, TypeVar, List, Tuple, MutableMapping

import dpath.util as dpath
import requests
from flask import Flask, render_template
from pathos.multiprocessing import ProcessPool
from typing_extensions import TypedDict

F = TypeVar('F', bound=Callable)

# --------------------------------- CONSTANTS ----------------------------------
ROOT = 'http://partners.api.skyscanner.net/apiservices/'
KEY = 'ha735495689835252807543252794422'
UID = 'i028f4656-cbb1-43fb-8952-5d1f0107a39e'

URLS = {
    'locales':    'reference/v1.0/locales',
    'markets':    'reference/v1.0/countries/%(locale)s',
    'currencies': 'reference/v1.0/currencies',
    'places':     '/autosuggest/v1.0/%(market)s/%(currency)s/%(locale)s?query=%(query)s',
    'quotes':     'browsequotes/v1.0/%(country)s/%(currency)s/%(locale)s/%(src)s/%(dst)s/%(date_out)s/%(date_in)s',
    'session':    '/pricing/v1.0',
}

BODY = 'cabinclass=Economy&country=%(country)s&currency=%(currency)s&locale=%(locale)s&locationSchema=sky&' \
       'originplace=%(src)s&destinationplace=%(dst)s&outbounddate=%(date_out)s&inbounddate=%(date_in)s&adults=1&' \
       f'children=0&infants=0&apikey={KEY}'

HEADERS = {
    'Content-Type': "application/x-www-form-urlencoded",
    'cache-control': "no-cache",
}


@dataclass
class Request:
    """Object that represents the state of every request, in table we build the results for the request"""
    req_id: int
    src: str
    dst: str
    date_out: str
    table: List[Tuple[(str, str, int, str)]] = field(default_factory=list)  # [(flag, country, price, url)]

    @property
    def poll_id(self) -> int:
        return self.req_id

    @poll_id.setter
    def poll_id(self, value: int) -> None:
        self.req_id = value


class Details(TypedDict, total=True):
    date_out: str
    date_in: str
    currency: str
    locale: str
    market: str
    src: str
    dst: str


REQUESTS = {
    0: Request(0, 'src', 'dst', 'date_out')
}


app = Flask(__name__)


# ------------------------------------------------------------------------------
# ------------------------------- API REQUESTS ---------------------------------
# ------------------------------------------------------------------------------
def to_url(part_url: str) -> str:
    """Append api key"""
    root, part_url = ROOT.rstrip('/'), part_url.strip('/')
    arg_sep = '&' if '?' in part_url else '?'
    return f'{root}/{part_url}{arg_sep}apiKey={KEY}'


def decode_response(part_url: str, *, encoding: str = 'utf-8', **kwargs: Any) -> Dict[str, Any]:
    """Makes a get request and decodes the response"""
    part_url = part_url % kwargs
    url = to_url(part_url)
    bstr = requests.get(url).content
    return cast(Dict[str, str], json.loads(bstr.decode(encoding)))


def post_response(part_url: str = URLS['session'], body: str = BODY, headers: Optional[Dict[str, str]] = None,
                  **kwargs: Any) -> MutableMapping[str, str]:
    body = body % kwargs
    root, part_url = ROOT.rstrip('/'), part_url.strip('/')
    url = f'{root}/{part_url}'
    return requests.post(url, data=body, headers=headers if headers is not None else HEADERS).headers


# ------------------------------------------------------------------------------
# -------------------------------- UTILITIES -----------------------------------
# ------------------------------------------------------------------------------
def pprint_requests(sort_keys=True) -> None:
    reqs = {req_id: len(req.table) for req_id, req in REQUESTS.items()}
    print(json.dumps(reqs, indent=4, sort_keys=sort_keys))


def extract(path: str) -> Callable[[F], F]:
    def decorator(func: F) -> F:
        def wrapper(*args, **kwargs):
            res = func(*args, **kwargs)
            return dpath.values(res, path)
        return cast(F, wrapper)
    return decorator


def duration(func: F) -> F:
    def wrapper(*args, **kwargs):
        start_time = time.time()
        try:
            res = func(*args, **kwargs)
        finally:
            time_elapsed = time.time() - start_time
            print(f'TOTAL TIME {func.__name__}: {time_elapsed} seconds')
        return res
    return cast(F, wrapper)


# ------------------------------------------------------------------------------
# ----------------------------- MARKETS SWEEPER --------------------------------
# ------------------------------------------------------------------------------
class MarketsSweeper:

    def __init__(  # pylint: disable=too-many-arguments
            self, src: str, dst: str, date_out: str, date_in: str = '',
            currency: str = 'GBP', locale: str = 'en-GB', init_market: str = 'ES'
    ) -> None:
        """
        Args:
            src      (str): outbound airport/ origin
            dst      (str): inbound airport / destination
            date_out (str): 'yyyy-mm-dd'
            date_in  (str): 'yyyy-mm-dd' or by def '' (oneway trip)
        """
        self.details: Details = {
            'date_out': date_out,
            'date_in':  date_in,
            'currency': currency,
            'locale':   locale,
            'market':   init_market,
            'src': self.get_place(src)[0],
            'dst': self.get_place(dst)[0]
        }
        print(f'FROM: {self.details["src"]} TO: {self.details["dst"]}')

    @extract('/Places/0/PlaceId')
    def get_place(self, query: str) -> List[str]:
        return cast(List[str], decode_response(URLS['places'], query=query, **self.details))

    def get_markets(self) -> Dict[str, str]:
        res = decode_response(URLS['markets'], **self.details)
        codes = dpath.values(res, '/Countries/*/Code')
        names = dpath.values(res, '/Countries/*/Name')
        return dict(zip(codes, names))

    @extract('/Quotes/*/MinPrice')
    def get_quotes(self, **kwargs) -> List[int]:  # TODO: check return type
        kwargs.update(self.details)
        return cast(List[int], decode_response(URLS['quotes'], **kwargs))

    @duration
    def sweep_cache(self, pool_size: int = 10) -> List[Tuple[str, str, List[int]]]:
        markets = self.get_markets()

        # Make parallel queries for each market
        pool = ProcessPool(pool_size)

        def get_quotes_(market: str) -> Dict[str, List[int]]:
            quotes = self.get_quotes(country=market)
            return {market: quotes}

        # Combine results
        all_quotes: Dict[str, List[int]] = {}
        for market_to_quotes in pool.map(get_quotes_, markets.keys()):
            all_quotes.update(market_to_quotes)

        # Sort
        res = [(market_, markets[market_], quotes) for market_, quotes in all_quotes.items()]
        return sorted(res, key=lambda t: (t[2], t[1]))

    def get_session(self, country: str) -> str:
        res = post_response(country=country, **self.details)
        try:
            session: str = dpath.get(res, '/Location')
            time.sleep(.1)
            session = session.rstrip('/')
            return f'{session}?apikey={KEY}'
        except BaseException:  # noqa
            print('R:', res)
            raise

    @duration
    def sweep_real_time(self, req_id: int, encoding: str = 'utf-8') -> None:
        global REQUESTS  # pylint: disable=global-statement  # TODO: use a proper database
        print(f'> Starting to sweep markets for request: {req_id}')
        markets = self.get_markets()
        for market in markets:
            url_to_poll = self.get_session(market)
            bstr = requests.get(url_to_poll).content
            res = json.loads(bstr.decode(encoding))
            prices = dpath.values(res, '/Itineraries/*/PricingOptions/*/Price')
            urls = dpath.values(res, '/Itineraries/*/PricingOptions/*/DeeplinkUrl')
            # Retrieve best price per market
            sorted_res = sorted(zip(prices, urls))
            prices, urls = zip(*sorted_res)
            if prices:
                entry = (market, markets[market], prices[0], urls[0])
                # Update reqs -> update file
                print('---------', entry)
                REQUESTS[req_id].table.append(entry)
        # Mark job completion
        REQUESTS[req_id].poll_id = 0

    @staticmethod
    @extract('/Locales/*/Code')
    def get_locales() -> List[str]:
        return cast(List[str], decode_response(URLS['locales']))

    @staticmethod
    @extract('/Currencies/*/Code')
    def get_currencies() -> List[str]:
        return cast(List[str], decode_response(URLS['currencies']))


# ------------------------------------------------------------------------------
# ---------------------------------- SERVER ------------------------------------
# ------------------------------------------------------------------------------
@app.route('/')
def index():
    return render_template('index.html')


@app.route('/getlive/<src>/<dst>/<date_out>')
def sweep_real_time(src, dst, date_out):
    # Allocate id
    req_id = max(REQUESTS.keys()) + 1
    REQUESTS[req_id] = Request(req_id, src, dst, date_out)
    print(f'> Allocated request id: {req_id}')
    # start a new thread to sweep markets for request id req_id
    sweep_markets = MarketsSweeper(src, dst, date_out).sweep_real_time
    Thread(target=sweep_markets, args=(req_id,)).start()
    return get_req(req_id)


@app.route('/req_id/<req_id>')
def get_req(req_id):
    req_id = int(req_id)
    pprint_requests()
    req = REQUESTS[req_id]
    table = sorted(req.table, key=lambda t: (t[2], t[1]))
    return render_template('loading.html', sofars=table, poll_id=req.poll_id, src=req.src, dst=req.dst,
                           date_out=req.date_out)


@app.route('/req_id_clicked/<req_id>')
def get_req_paused(req_id):
    req_id = int(req_id)
    pprint_requests()
    req = REQUESTS[req_id]
    table = sorted(req.table, key=lambda t: (t[2], t[1]))
    return render_template('loading-clicked.html', sofars=table, poll_id=req.poll_id, src=req.src, dst=req.dst,
                           date_out=req.date_out)


@app.route('/getprice/<src>/<dst>/<date_out>')
def sweep_cache(src, dst, date_out):
    return render_template('index-table.html', res=MarketsSweeper(src, dst, date_out).sweep_cache())


if __name__ == '__main__':
    # Create a command line argument parser
    parser = ArgumentParser(description='JobAllocator. Manage task allocation for asynchronous distributed tasks.')
    # Add a job id argument
    parser.add_argument('--flaskport', action="store", default='5000', help="ID of the currently running JOB")
    # Parse command line args
    clargs = parser.parse_args()
    # Access command line argument
    input_port = clargs.flaskport

    app.run(host='localhost', port=input_port, debug=False)
