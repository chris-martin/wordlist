{-# LANGUAGE NoImplicitPrelude, ScopedTypeVariables #-}

module Main (main) where

import Wordlist.Args (Args, getArgs, argsNumber, argsDelimiter)

import Control.Monad.Random (Rand, RandomGen, evalRandIO, getRandomRs)
import Data.Text (Text)
import Data.Vector (Vector)
import Prelude hiding (words)
import System.Environment (getEnv)
import System.IO (hFlush, hPutStr, stderr, stdout)

import qualified Data.Text as Text
import qualified Data.Text.IO as TextIO
import qualified Data.Vector as Vector

main :: IO ()
main =
  readInputs >>= selectWords >>= writeOutput

readInputs :: IO (Args, Vector Text)
readInputs =
    (,) <$> getArgs <*> getWords
  where
    getWords :: IO (Vector Text)
    getWords = do
      path <- getEnv "WORD_LIST_PATH"
      text <- TextIO.readFile path
      return $ Vector.fromList $ Text.lines $ text

selectWords :: (Args, Vector Text) -> IO (Args, Vector Text)
selectWords (args, allWords) =
    evalRandIO $ do
      selectedWords <- randomRsVector allWords
      return (args, Vector.fromList $ take (argsNumber args) selectedWords)
  where
    randomRsVector :: (RandomGen g) => Vector a -> Rand g [a]
    randomRsVector xs = do
      indices <- getRandomRs (0, Vector.length xs - 1)
      return $ fmap (xs Vector.!) indices

writeOutput :: (Args, Vector Text) -> IO ()
writeOutput (args, words) =
  do
    TextIO.putStr $ Text.intercalate (argsDelimiter args) (Vector.toList words)
    hFlush stdout
    hPutStr stderr "\n"
