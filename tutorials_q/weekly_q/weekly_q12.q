simChildOrders:{[nOrders]
    seed:-314159;
    openTime:`time$09:30;
    closeTime:`time$16:00;
    litVenues:`XNYS`ARCX`XCHI`XASE`XCIS`XNAS`XBOS`XPHL`BATS`BATY`EDGA`EDGX`IEXG;

    system "S ",string seed;
    submitTimes:asc closeTime&openTime+nOrders?390*60*1000;

    system "S ",string seed;
    exDest:nOrders?litVenues;

    system "S ",string seed;
    nExchanges:3+nOrders?(count litVenues)-3;
    system "S ",string seed;
    nbbVenues:{y?x}[litVenues;] each nExchanges;

    ([] time:submitTimes;side:`BUY;exDest:exDest;nbbVenues:nbbVenues)
    };

childOrders:simChildOrders[5000];

tt:exec sum in'[exDest;nbbVenues] from childOrders;
t:select from (update isAtNBBO:{[exDest;nbbVenues] exDest in nbbVenues}'[exDest;nbbVenues] from childOrders) where isAtNBBO;
show tt;
show t;
