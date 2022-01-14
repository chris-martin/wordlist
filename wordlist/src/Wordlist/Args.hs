{-# LANGUAGE OverloadedStrings #-}

module Wordlist.Args
  ( Args (..), getArgs, argsNumber, argsDelimiter

  -- * Parser details
  , argsP
  , defaultNumber, defaultDelimiter
  , numberP, delimiterP
  ) where

import Control.Applicative (optional)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Options.Applicative.Extra (execParser, helper)
import Options.Applicative.Types (Parser)

import qualified Data.Text as Text
import qualified Options.Applicative.Builder as Opt

data Args = Args
  { argsNumberMaybe :: Maybe Int
  , argsDelimiterMaybe :: Maybe Text
  }

defaultNumber :: Int
defaultNumber = 4

defaultDelimiter :: Text
defaultDelimiter = " "

numberP :: Parser (Maybe Int)
numberP =
    optional $ Opt.option Opt.auto $
    Opt.long "number" <> Opt.short 'n' <> Opt.help help
  where
    help = "Number of words (default: " <>
           show defaultNumber <> ")"

delimiterP :: Parser (Maybe Text)
delimiterP =
    optional $ Opt.option (fmap Text.pack Opt.str) $
    Opt.long "delimiter" <> Opt.short 'd' <> Opt.help help
  where
    help = "Delimiter between words (default: space)"

argsP :: Parser Args
argsP =
  Args <$> numberP <*> delimiterP

parserInfo :: Opt.InfoMod a
parserInfo =
  Opt.header
  "Generates random English words. Useful for password generation."

getArgs :: IO Args
getArgs =
  execParser $ Opt.info (helper <*> argsP) parserInfo

argsNumber :: Args -> Int
argsNumber =
  fromMaybe defaultNumber . argsNumberMaybe

argsDelimiter :: Args -> Text
argsDelimiter =
  fromMaybe defaultDelimiter . argsDelimiterMaybe
