genCO:{[parentId;waveId;side]
    n:-5;

    system "S -314159";
    ids:`long$.z.N+n?1000;

    system "S -314159";
    prices:100+0.01*n?100;

    system "S -314159";
    sizes:100*1+n?10;

    :([] poid:parentId;wid:waveId;coid:ids;side:side;price:prices;size:sizes)
  };

genOrders:{
    buyOrders:raze {poid:`long$22:32:12.163;genCO[poid;x;`BUY]} each 101+til 20;
    sellOrders:raze {poid:`long$23:32:12.163;genCO[poid;x;`SELL]} each 101+til 20;
    buyOrders,sellOrders
  };

orders:genOrders[];
raze {
    f:$[x=`BUY;max;min];
    :select from orders where side=x, price = (f;price) fby wid
} each `BUY`SELL


{
  data:`poid`wid`p xasc update p:?[side=`BUY;price;-1*price] from orders;
  data:delete p from data;
  0!select by poid,wid from data
}[]