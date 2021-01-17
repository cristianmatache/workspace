module Ex1To10 where

-- Ex 1
myLast :: [a] -> a
myLast [x] = x
myLast (_:xs) = myLast xs

safeMyLast :: [a] -> Maybe a
safeMyLast [] = Nothing
safeMyLast [x] = Just x
safeMyLast (_:xs) = safeMyLast xs


-- Ex2
myButLast :: [a] -> a
myButLast [x, _] = x
myButLast (_:xs) = myButLast xs

safeMyButLast :: [a] -> Maybe a
safeMyButLast [] = Nothing
safeMyButLast [_] = Nothing
safeMyButLast [x, _] = Just x
safeMyButLast (_:xs) = safeMyButLast xs

-- Ex3
elementAt :: [a] -> Int -> a
elementAt xs n = xs !! n

elementAtSafe :: [a] -> Int -> Maybe a
elementAtSafe [] n = Nothing
elementAtSafe (x:_) 0 = Just x
elementAtSafe (x:xs) n = elementAtSafe xs (n-1)

-- Ex4
myLength :: [a] -> Int
myLength [] = 0
myLength (_:xs) = 1 + myLength xs


-- Ex5
myReverse :: [a] -> [a]
myReverse = myReverseAcc []
    where
        myReverseAcc = foldl (flip (:))

-- Ex6
isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs = xs == reverse xs