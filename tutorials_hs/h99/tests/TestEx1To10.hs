module TestEx1To10 where

import Ex1To10 (myLast, myButLast)
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

-- All tests
tests :: Test
tests = TestList [
    -- Ex1
    TestLabel "testMyLastStr" testMyLastStr,
    TestLabel "testMyLastListInt" testMyLastListInt,
    -- Ex2
    TestLabel "testMyButLastStr" testMyButLastStr,
    TestLabel "testMyButLastListInt" testMyButLastListInt
    ]
