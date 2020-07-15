isLeapYear1: {[year]:not `boolean$$[year mod 100; (year-2020) mod 4; year mod 400]};

isLeapYear2:{mod[;2] sum 0=x mod\: 4 100 400};

2020 mod\: 4 100 400
0=mod[2020;] each  4 100 400
each


isLeapYear: isLeapYear2;
(
isLeapYear 1800; / 0b
isLeapYear 1900; / 0b
isLeapYear 2000; / 1b
isLeapYear 2020; / 1b
)


{{x;y;z} . 0=x mod\: 100 400 4} 1800
{x;y;z} . 0=1800 mod\: 100 400 4
{x;y;z}[0b;1b;0b]

isLeapYear1:{{x;y;z} . 0=x mod\: 100 400 4};
