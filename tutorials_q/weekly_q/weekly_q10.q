dataList:(
   "date,sym,order type,orderQty"
  ;"2020.03.09,AAPL.OQ,MID QUOTE,80000"
  ;"2020.03.09,AAPL.OQ,FAR TOUCH,50000"
  ;"2020.03.09,AAPL.OQ,NEAR TOUCH,120000"
  ;"2020.03.10,AAPL.OQ,MID QUOTE,100000"
  ;"2020.03.10,AAPL.OQ,FAR TOUCH,70000"
  ;"2020.03.10,AAPL.OQ,NEAR TOUCH,170000"
  ;"2020.03.09,IBM.N,MID QUOTE,83000"
  ;"2020.03.09,IBM.N,FAR TOUCH,54000"
  ;"2020.03.09,IBM.N,NEAR TOUCH,129000"
  ;"2020.03.10,IBM.N,MID QUOTE,130000"
  ;"2020.03.10,IBM.N,FAR TOUCH,79000"
  ;"2020.03.10,IBM.N,NEAR TOUCH,175000"
  ;"2020.03.09,BABA.N,MID QUOTE,120000"
  ;"2020.03.09,BABA.N,FAR TOUCH,68000"
  ;"2020.03.09,BABA.N,NEAR TOUCH,930000"
  ;"2020.03.10,BABA.N,MID QUOTE,150000"
  ;"2020.03.10,BABA.N,FAR TOUCH,96000"
  ;"2020.03.10,BABA.N,NEAR TOUCH,2030000"
);
dataTbl:("DSSJ"; enlist ",") 0:dataList;
parse "select sum orderQty by abla, sym from dataTbl"

?[dataTbl;();(`$"order type";`sym)!(`$"order type";`sym);enlist[`orderQty]!enlist (sum;`orderQty)]
?[dataTbl;();enlist[`orderType]!enlist `$"order type";enlist[`totalOrderQty]!enlist (sum;`orderQty)]

?[dataTbl;enlist (=;`$"order type";enlist`$"MID QUOTE");0b;enlist[`orderQty]!enlist (sum;`orderQty)]
