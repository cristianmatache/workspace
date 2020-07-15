simSlippage:{
    n:10000;

    system "S -314159";
    slippage:5-0.01*n?1000;  / uniform [-5, 5]

    system "S -314159";
    notional:10000+n?100000;  / uniform [10_000, 110_000]

    :([] notional:notional;slippage:slippage)
  };

perfData:simSlippage[];

select notional wavg slippage from perfData

//notional_avg: exec notional wavg slippage from perfData;
//n_prime: count exec slippage from perfData where slippage <> 0;
//denom: (n_prime - 1) * sum[perfData[`slippage]] % n_prime;
//nom: ((perfData[`notional] - notional_avg) * (perfData[`notional] - notional_avg)) wavg perfData[`slippage];
//sqrt nom % denom


wstd: {[xs; ws]

    n: sum ws<>0;
    :sqrt (n%n-1) * ws wavg  xdm * xdm: xs - ws wavg xs;
};

exec wstd[slippage; notional] from perfData

wsdev: {[w;x]
    :$[1>=n:sum w<>0; :0f;sqrt (n%n-1)*w wavg xdm*xdm:x-w wavg x
    ]
  };

exec wsdev[notional;slippage] from perfData
