module Main where
import System.Environment

main :: IO ()
main = do
    putStrLn "Type name"
    name <- getLine
    putStrLn name
