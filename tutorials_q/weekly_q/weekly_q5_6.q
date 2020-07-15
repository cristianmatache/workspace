genOrders:{[nOrders;seed;openTime;closeTime]
    system "S ",string seed;
    submitTimes:asc closeTime&openTime+nOrders?390*60*1000;

    system "S ",string seed;
    exitTimes:closeTime&submitTimes+nOrders?60*1000;

    ([] orderId:1000+til nOrders;subT:submitTimes;exitT:exitTimes)
  };

openTime:`time$09:30;
closeTime:`time$16:00;
simOrders:genOrders[5000;-314159;openTime;closeTime];

t: `time xasc (select time:subT, isExit:0b from simOrders),(select time:exitT, isExit:1b from simOrders);
select by time from t

t: update maxExit:maxs exitT from simOrders;
update diff:subT-prev maxExit from t

times:update maxT:maxs exitT from simOrders;
times:update noOrderDur:subT-prev maxT from times;
times:update noOrderDur:subT-openTime from times where null noOrderDur;
select startTime:`time$subT-noOrderDur,periodLength:`time$noOrderDur from times where noOrderDur>0

simOrders

initOrder:([] time:enlist openTime;nOpenOrders:enlist 0);
addOrder:select time:subT,nOpenOrders:1 from simOrders;
removeOrder:select time:exitT,nOpenOrders:-1 from simOrders;
orders:select time,sums nOpenOrders from `time xasc initOrder,addOrder,removeOrder;
select time,nOpenOrders from orders where differ nOpenOrders