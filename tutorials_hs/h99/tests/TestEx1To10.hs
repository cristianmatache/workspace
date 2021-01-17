module TestEx1To10 where

import Ex1To10 (myLast, myButLast, elementAtCustom)
import Test.HUnit ( Test( TestCase, TestList, TestLabel ), assertEqual, runTestTT)

-- Ex1
testMyLastStr :: Test
testMyLastStr = TestCase (assertEqual "myLast string" 'c' $ myLast "abc")

testMyLastListInt :: Test
testMyLastListInt = TestCase (assertEqual "myLast list ints" 3 $ myLast [1..3])

-- Ex2
testMyButLastStr :: Test
testMyButLastStr = TestCase (assertEqual "myButLast string" 'b' $ myButLast "abc")

testMyButLastListInt :: Test
testMyButLastListInt = TestCase (assertEqual "myButLast list ints" 2 $ myButLast [1..3])


-- Ex3
testElementAtCustomEmpty = TestCase (assertEqual "elementAtCustom empty" Nothing $ elementAtCustom "" 2)
testElementAtCustomHead = TestCase (assertEqual "elementAtCustom normal head" (Just 'h') $ elementAtCustom "haskell" 0)
testElementAtCustomMid = TestCase (assertEqual "elementAtCustom normal middle" (Just 's') $ elementAtCustom "haskell" 2)
testElementAtCustomOOB = TestCase (assertEqual "elementAtCustom normal OOB" Nothing $ elementAtCustom "haskell" 100)
testElementAtCustomNeg = TestCase (assertEqual "elementAtCustom negative" Nothing $ elementAtCustom "haskell" (-1))


-- All tests
tests :: Test
tests = TestList [
    -- Ex1
    TestLabel "testMyLastStr" testMyLastStr,
    TestLabel "testMyLastListInt" testMyLastListInt,
    -- Ex2
    TestLabel "testMyButLastStr" testMyButLastStr,
    TestLabel "testMyButLastListInt" testMyButLastListInt,
    -- Ex3
    TestLabel "testElementAtCustomEmpty" testElementAtCustomEmpty,
    TestLabel "testElementAtCustomHead" testElementAtCustomHead,
    TestLabel "testElementAtCustomMid" testElementAtCustomMid,
    TestLabel "testElementAtCustomOOB" testElementAtCustomOOB,
    TestLabel "testElementAtCustomNeg" testElementAtCustomNeg
    ]

-- To run the tests:
--  :l TestEx1To10.hs
--  runTestTT tests