# pylint:disable=all  # Astroid still fails with maximum recursion depth
from contextlib import contextmanager
from dataclasses import dataclass, field
from getpass import getuser
from pathlib import Path
from typing import Any, Dict, Generator, List, Tuple

from flask import Flask, redirect, render_template
from flask_assets import Bundle, Environment
from pandas import DataFrame
from qpython.qconnection import QConnection
from werkzeug.wrappers import Response

# FLASK THINGS
app = Flask(__name__)
assets = Environment(app)
assets.url = app.static_url_path
scss = Bundle('index-tenant.css', 'landlord-flat-details.css', filters='pyscss', output='all.css')


assets.config['SECRET_KEY'] = 'secret!'  # nosec
assets.config['PYSCSS_LOAD_PATHS'] = assets.load_path
assets.config['PYSCSS_STATIC_URL'] = assets.url
assets.config['PYSCSS_STATIC_ROOT'] = assets.directory
assets.config['PYSCSS_ASSETS_URL'] = assets.url
assets.config['PYSCSS_ASSETS_ROOT'] = assets.directory

assets.register('scss_all', scss)


@dataclass
class Server:
    host: str
    port: int


@dataclass
class KDBServer(Server):
    username: str
    password: str = field(repr=False)


KDB_FILE_PATH = (Path(__file__).parent / 'database.q').as_posix()
KDB_SERVER = {
    'oana': KDBServer('localhost', 5000, 'oana', '123'),
    'Cristian Matache': KDBServer('localhost', 5000, 'crm', 'crm'),
}[getuser()]
FLASK_SERVER = Server('localhost', 6000)

COLUMNS_TO_CONVERT = ('tenantName', 'tenantEmail', 'tenantPhone', 'job', 'postcode', 'flatImage', 'flatName',
                      'landlordName', 'landlordEmail', 'landlordPhone')


@contextmanager
def q_connection() -> Generator[QConnection, None, None]:
    with QConnection(KDB_SERVER.host, KDB_SERVER.port, KDB_SERVER.username, KDB_SERVER.password) as q:
        yield q


# ------------------------------------------------------- UTILS -------------------------------------------------------
def df_to_list_of_tuples(df: DataFrame) -> List[Tuple[Any, ...]]:
    return [tuple(row) for row in df.values]


def convert_byte_strings(df: DataFrame, *, columns: Tuple[str, ...] = COLUMNS_TO_CONVERT) -> DataFrame:
    for column in columns:
        df[column] = df[column].str.decode('utf-8')
    return df


@app.route('/')
def index() -> str:
    return 'Are you a landlord or a tenant?'


# ------------------------------------------------------ LANDLORD -----------------------------------------------------
@app.route('/get-homepage-landlord/<landlord_id>')
def landlord_home(landlord_id: str) -> Any:
    """landlord home page."""
    with q_connection() as q:
        all_flats = q(f'0!getFlatsOverviewPerLandlord[{landlord_id}]', pandas=True)
        landlord_name = q(f'getLandlordInfo[{landlord_id};`landlordName]', pandas=False).decode("utf-8")

    all_flats = convert_byte_strings(all_flats, columns=('postcode', 'flatName', 'flatImage'))

    return render_template('landlord-index.html', all_flats=df_to_list_of_tuples(all_flats),
                           landlord_id=landlord_id, landlord_name=landlord_name)


@app.route('/landlord-viewings/<landlord_id>/')
def landlord_viewings(landlord_id: str) -> Any:
    """landlord viewings page (TODO: decline tenants and cancel viewings from here)"""
    with q_connection() as q:
        landlord_name = q(f'getLandlordInfo[{landlord_id};`landlordName]', pandas=False).decode("utf-8")
        viewings: Dict[str, List[Tuple[Any, ...]]] = {
            'upcoming':      df_to_list_of_tuples(q(f'getViewings[`landlord; {landlord_id}; `upcoming]')),
            'not_confirmed': df_to_list_of_tuples(q(f'getViewings[`landlord; {landlord_id}; `notConfirmed]')),
            'viewed':        df_to_list_of_tuples(q(f'getViewings[`landlord; {landlord_id}; `viewed]')),
            'declined':      df_to_list_of_tuples(q(f'getViewings[`landlord; {landlord_id}; `declined]'))
        }
    return render_template('landlord-viewings.html', landlord_name=landlord_name,
                           upcoming=viewings["upcoming"], not_confirmed=viewings["not_confirmed"],
                           viewed=viewings["viewed"], declined=viewings["declined"])


@app.route('/flat-details/<flat_id>/')
def landlord_flat_details(flat_id: str) -> Any:
    with q_connection() as q:

        def q_convert(query: str) -> List[Tuple[Any, ...]]:
            res = convert_byte_strings(q(query, pandas=True))
            res['viewingDate'] = res['viewingDate'].apply(lambda date: date.strftime('%Y.%m.%d'))
            return df_to_list_of_tuples(res)

        landlord_id = q(f'getLandlordPerFlat[{flat_id}]')
        landlord_name = q(f'getLandlordInfo[{landlord_id};`landlordName]', pandas=False).decode("utf-8")

        viewings: Dict[str, List[Tuple[Any, ...]]] = {
            'upcoming': q_convert(f'getViewingsPerFlat[{flat_id}; `upcoming]'),
            'not_confirmed': q_convert(f'getViewingsPerFlat[{flat_id}; `notConfirmed]'),
            'viewed': q_convert(f'getViewingsPerFlat[{flat_id}; `viewed]'),
            'declined': q_convert(f'getViewingsPerFlat[{flat_id}; `declined]')
        }

        flat_info_df = q(f'getFlatInfo[{flat_id}]', pandas=True)
        flat_info = df_to_list_of_tuples(convert_byte_strings(flat_info_df,
                                                              columns=('postcode', 'flatImage', 'flatName')))

    return render_template('landlord-flat-details.html', landlord_name=landlord_name,
                           upcoming=viewings["upcoming"], not_confirmed=viewings["not_confirmed"],
                           viewed=viewings["viewed"], declined=viewings["declined"],
                           upcoming_empty=bool(viewings["upcoming"]), not_conf_empty=bool(viewings["not_confirmed"]),
                           viewed_empty=bool(viewings["viewed"]), declined_empty=bool(viewings["declined"]),
                           flat_info=flat_info, landlord_id=landlord_id)


@app.route('/decline-tenant/<flat_id>/<tenant_id>')
def decline_tenant(flat_id: str, tenant_id: str) -> Response:
    with q_connection() as q:
        q(f'declineTenant[{flat_id};{tenant_id}]')
    return redirect(f'/flat-details/{flat_id}')


@app.route('/confirm-viewing-landlord/<flat_id>/<tenant_id>/<date>')
def confirm_viewing(flat_id: str, tenant_id: str, date: str) -> Response:
    with q_connection() as q:
        q(f'amendViewing[{flat_id};{tenant_id};{date};`confirm]')
    return redirect(f'/flat-details/{flat_id}')


@app.route('/cancel-viewing-landlord/<flat_id>/<tenant_id>/<date>')
def cancel_viewing_landlord(flat_id: str, tenant_id: str, date: str) -> Response:
    with q_connection() as q:
        q(f'amendViewing[{flat_id};{tenant_id};{date};`cancel]')
    return redirect(f'/flat-details/{flat_id}/')


# ------------------------------------------------------- TENANT ------------------------------------------------------

@app.route('/get-homepage-tenant/<tenant_id>')
def tenant_home(tenant_id: str) -> Any:
    """tenant home page."""
    with q_connection() as q:
        all_flats = q('0!getFlatsInfo[]', pandas=True)
        tenant_name = q(f'getTenantInfo[{tenant_id};`tenantName]', pandas=False).decode("utf-8")

    all_flats = convert_byte_strings(all_flats, columns=('postcode', 'flatName', 'flatImage'))

    return render_template('tenant-index.html', all_flats=df_to_list_of_tuples(all_flats),
                           tenant_id=tenant_id, tenant_name=tenant_name)


@app.route('/tenant-viewings/<tenant_id>/')
def tenant_viewings(tenant_id: str) -> Any:
    """tenant viewings page."""
    with q_connection() as q:
        tenant_name = q(f'getTenantInfo[{tenant_id};`tenantName]', pandas=False).decode("utf-8")

        def q_convert(query: str) -> List[Tuple[Any, ...]]:
            res = convert_byte_strings(q(query, pandas=True))
            res['viewingDate'] = res['viewingDate'].apply(lambda date: date.strftime('%Y.%m.%d'))
            return df_to_list_of_tuples(res)

        viewings: Dict[str, List[Tuple[Any, ...]]] = {
            'upcoming':      q_convert(f'getViewings[`tenant; {tenant_id}; `upcoming]'),
            'not_confirmed': q_convert(f'getViewings[`tenant; {tenant_id}; `notConfirmed]'),
            'viewed':        q_convert(f'getViewings[`tenant; {tenant_id}; `viewed]'),
            'declined':      q_convert(f'getViewings[`tenant; {tenant_id}; `declined]')
        }
    return render_template('tenant-viewings.html', tenant_name=tenant_name, tenant_id=tenant_id,
                           upcoming=viewings["upcoming"], not_confirmed=viewings["not_confirmed"],
                           viewed=viewings["viewed"], declined=viewings["declined"],
                           upcoming_empty=bool(viewings["upcoming"]), not_conf_empty=bool(viewings["not_confirmed"]),
                           viewed_empty=bool(viewings["viewed"]), declined_empty=bool(viewings["declined"]))


@app.route('/tenant-bio/<tenant_id>/')
def tenant_bio(tenant_id: str) -> Any:
    """tenant bio page."""
    with q_connection() as q:
        details = {
            'name':        q(f'getTenantInfo[{tenant_id};`tenantName]').decode("utf-8"),
            'email':       q(f'getTenantInfo[{tenant_id};`tenantEmail]').decode("utf-8"),
            'phone':       q(f'getTenantInfo[{tenant_id};`tenantPhone]').decode("utf-8"),
            'age':         q(f'getTenantInfo[{tenant_id};`age]'),
            'is_employed': q(f'getTenantInfo[{tenant_id};`employment]'),
            'salary':      q(f'getTenantInfo[{tenant_id};`yearlyIncome]'),
            'job':         q(f'getTenantInfo[{tenant_id};`job]').decode("utf-8"),
        }
    return render_template('tenant-bio.html', **details, tenant_id=tenant_id)


@app.route('/schedule-viewing/<flat_id>/<tenant_id>/<date>')
def schedule_viewing(flat_id: str, tenant_id: str, date: str) -> Response:
    """Only tenants can ask for a viewing, landlords can only decline/accept it."""
    with q_connection() as q:
        print('SCHEDULING')
        q(f'scheduleViewing[{flat_id};{tenant_id};{date}]')
    return redirect(f'/tenant-viewings/{tenant_id}/')


@app.route('/cancel-viewing-tenant/<flat_id>/<tenant_id>/<date>')
def cancel_viewing_tenant(flat_id: str, tenant_id: str, date: str) -> Response:
    with q_connection() as q:
        q(f'amendViewing[{flat_id};{tenant_id};{date};`cancel]')
    return redirect(f'/tenant-viewings/{tenant_id}/')


if __name__ == '__main__':
    with q_connection() as q_:
        q_(f'system "l {KDB_FILE_PATH}"')
    print(f'Loaded {KDB_FILE_PATH}')
    app.run(FLASK_SERVER.host, FLASK_SERVER.port, debug=False)
