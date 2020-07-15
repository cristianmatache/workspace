getTradingDays:{
    firstDate:2020.03.01;
    lastDate:2020.03.31;
    dates:firstDate+til (lastDate-firstDate)+1;
    dates where not (dates mod 7) in 0 1
  };

simulateTrades:{[seed;nTrades]
    tradingDays:getTradingDays[];

    system "S ",string seed;
    dates:nTrades?tradingDays;

    system "S ",string seed;
    tickers:nTrades?`3;

    system "S ",string seed;
    volumes:100*nTrades?1+til 100;

    ([] date:dates;ticker:tickers;volume:volumes)
  };

trades:simulateTrades[-314159;5000000];

topTradedSymbols:([]
  date:`date$();
  ticker:`symbol$();
  dailyVol:`long$()
);

dailyVols:`date`dailyVol xdesc select dailyVol:sum volume by date, ticker from trades;

ungroup select 10#ticker,10#dailyVol by date from dailyVols
select from dailyVols where ({x in 10#x};i) fby date
select from dailyVols where i in raze 10#/:group date


raze {10 sublist `dailyVol xdesc select from dailyVols where date=x} each exec distinct date from dailyVols
