module Ex1To10 where

-- Ex 1
myLast :: [a] -> a
myLast (x:[]) = x
myLast (_:xs) = myLast xs

safeMyLast :: [a] -> Maybe a
safeMyLast [] = Nothing
safeMyLast (x:[]) = Just x
safeMyLast (_:xs) = safeMyLast xs


-- Ex2
myButLast :: [a] -> a
myButLast (x:_:[]) = x
myButLast (_:xs) = myButLast xs

safeMyButLast :: [a] -> Maybe a
safeMyButLast [] = Nothing
safeMyButLast (_:[]) = Nothing
safeMyButLast (x:_:[]) = Just x
safeMyButLast (_:xs) = safeMyButLast xs