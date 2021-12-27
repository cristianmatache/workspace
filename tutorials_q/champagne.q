//https://www.elliswines.co.uk/node/639
fields: `manufacturer`name`pinotNoir`chardonnay`pinotMeunier`rose`ageing;

// Blancs
moetEtChandonBrut:fields!(`$"Moet et Chandon";`$"Brut Imperial";37;37;26;0b;`NV);
moetEtChandonNectar:fields!(`$"Moet et Chandon";`$"Nectar Imperial";45;15;40;0b;`NV);
moetEtChandonIce:fields!(`$"Moet et Chandon";`$"Ice Imperial";45;15;40;0b;`NV);
veuveClicquotBrut:fields!(`$"Veuve Clicquot";`$"Brut";52;31;17;0b;`NV);
laurentPerrierBrut:fields!(`$"Laurent Perrier";`$"Cuvee Brut";40;45;15;0b;`NV);
bollingerCuvee:fields!(`$"Bollinger";`$"Special Cuvee";60;25;15;0b;`NV);
heidsieckMonopoleBlueTop:fields!(`$"Monopole Heidsieck";`$"Blue Top Brut";70;20;10;0b;`NV);
piperHeidsieckCuveeBrut:fields!(`$"Piper Heidsieck";`$"Cuvee Brut";55;15;30;0b;`NV);
lansonBlackLabel:fields!(`$"Lanson";`$"Black Label Brut";50;35;15;0b;`NV);
lansonWhiteLabel:fields!(`$"Lanson";`$"Black Label Brut";50;35;15;0b;`NV);
taittangerBrut:fields!(`$"Taittinger";`$"Brut Reserve";35;40;35;0b;`NV);

louisRoedererBrutPremier:fields!(`$"Louis Roederer";`$"Brut Premier";56;34;10;0b;`NV);
louisRoedererCristal:fields!(`$"Louis Roederer";`$"Cristal";55;45;0;0b;`NV);
perrierJoetGrandBrut:fields!(`$"Perrier Jouet";`$"Grand Brut";40;20;40;0b;`NV);
mummCordonRouge:fields!(`$"GH Mumm";`$"Cordon Rouge Brut";45;30;25;0b;`NV);

// Roses
moetEtChandonRose:fields!(`$"Moet et Chandon";`$"Rose Imperial";45;20;35;1b;`NV);
moetEtChandonNectarRose:fields!(`$"Moet et Chandon";`$"Nectar Imperial Rose";50;40;10;1b;`NV);
moetEtChandonIceRose:fields!(`$"Moet et Chandon";`$"Ice Rose";50;40;10;1b;`NV);
veuveClicquotRose:fields!(`$"Veuve Clicquot";`$"Rose";52;30;18;1b;`NV);
laurentPerrierRose:fields!(`$"Laurent Perrier";`$"Cuvee Rose";100;0;0;1b;`NV);
bollingerRose:fields!(`$"Bollinger";`$"Rose";62;24;14;1b;`NV);
piperHeidsieckRoseSauvage:fields!(`$"Piper Heidsieck";`$"Rose Sauvage";55;15;30;1b;`NV);
lansonPinkLabel:fields!(`$"Lanson";`$"Pink Label";53;32;15;1b;`NV);
taittangerPrestigeRose:fields!(`$"Taittanger";`$"Prestige Rose";45;30;25;1b;`NV);
ruinartRose:fields!(`Ruinart;`Rose;55;45;0;1b;`NV);

perrierJoetBERose:fields!(`$"Perrier Jouet";`$"Belle Epoque Rose";50;45;5;1b;`NV);

t:(
// Blancs
moetEtChandonBrut;moetEtChandonNectar;moetEtChandonIce;veuveClicquotBrut;
laurentPerrierBrut;bollingerCuvee;heidsieckMonopoleBlueTop;piperHeidsieckCuveeBrut;lansonBlackLabel;lansonWhiteLabel;
taittangerBrut; louisRoedererBrutPremier;
louisRoedererCristal;perrierJoetGrandBrut;mummCordonRouge;
// Roses
moetEtChandonRose;moetEtChandonNectarRose;moetEtChandonIceRose;veuveClicquotRose;
laurentPerrierRose;bollingerRose;piperHeidsieckRoseSauvage;lansonPinkLabel;taittangerPrestigeRose;
ruinartRose;perrierJoetBERose);
t:update noir:pinotNoir+pinotMeunier from t;

update tot:chardonnay+pinotNoir+pinotMeunier from t;

`noir xdesc (select from t where not rose);
`noir xdesc (select from t where rose);
`noir xdesc t;

t
select from t where manufacturer=`$"Moet et Chandon"
select from t where rose=1b
select avg pinotNoir by rose from t
select max pinotNoir by manufacturer from t