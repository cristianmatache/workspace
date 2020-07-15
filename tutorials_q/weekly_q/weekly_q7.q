paramTbl:([]time:`time$();orderQty:`long$();limitPrice:`float$();params:());
`paramTbl insert (09:30:56.123;500000;0n;`StartTime`PovRate!(10:00:00.000;0.08));
`paramTbl insert (09:35:44.735;500000;0n;`StartTime`PovRate!(09:40:00.000;0.08));
`paramTbl insert (10:01:25.941;500000;0n;`StartTime`PovRate!(09:40:00.000;0.12));
`paramTbl insert (10:10:32.356;500000;0n;`StartTime`PovRate`MinPovRate`MaxPovRate!(09:40:00.000;0.12;0.10;0.14));
`paramTbl insert (10:30:39.475;500000;45.23;`StartTime`PovRate`MinPovRate`MaxPovRate!(09:40:00.000;0.12;0.10;0.14));
`paramTbl insert (11:00:52.092;600000;45.27;`StartTime`PovRate`MinPovRate`MaxPovRate!(09:40:00.000;0.12;0.10;0.14));
`paramTbl insert (11:00:52.092;1000000;0n;`StartTime`PovRate!(09:40:00.000;0.15));

/ 1
keyUnion:(union) over exec key'[params] from paramTblCopy:paramTbl;
delete params from ![`paramTblCopy;();0b;keyUnion!{[col] ((';{[params;col]:params[col]}[;col]);`params)} each keyUnion]

/ 2
{[paramTbl]
  / Merge all parameters into a single dictionary so as to get a full list of parameter names
  allParams:raze exec params from paramTbl;

  / Find the null value for each parameter name
  nullValues:(key allParams)!(enlist each value allParams)[;1];

  / Create a table of "parameter" change history of order qty and limit price
  params1:select time,OrderQty:orderQty,LimitPrice:limitPrice from paramTbl;

  / Set a proper null value to parameters that are not present
  params2:exec {x,y}[nullValues;] each params from paramTbl;

  / Combine the normal parameters with the pseudo parameters
  params1,'params2
}[paramTbl]
