h: hsym `$"D:/workspace/q/src/weekly-q/nasdaqlisted.txt";
t: -1_("SSSSSJSB";enlist "|") 0: h;
t: `symbol`securityName`marketCategory`isTestIssue`financialStatus`lotSize`isETF`nextShares xcol t;
t: `symbol`marketCategory`isTestIssue`lotSize`isETF`securityName xcols t;
t:update isTestIssue:isTestIssue<>`N, isETF:isETF<>`N from t;
meta t
