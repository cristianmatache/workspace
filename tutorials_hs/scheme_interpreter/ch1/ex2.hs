module Main where
import System.Environment

main :: IO ()
main = do
   args <- getArgs
   let arg1 = read (head args)::Int
       arg2 = read (args !! 1)::Int
       argSum = show (arg1 + arg2)
   putStrLn argSum
