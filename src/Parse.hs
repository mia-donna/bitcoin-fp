{-# LANGUAGE DeriveGeneric #-}

module Parse where

import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L8
import GHC.Generics

data Record = Record {
           code :: String,
           symbol :: String,
           rate :: String,
           description :: String
    } deriving (Show, Generic)

instance FromJSON Record
instance ToJSON Record

data Records = Records {
            records :: [Record]
      }  deriving (Show, Generic)

instance FromJSON Records
instance ToJSON Records

parse :: L8.ByteString -> Either String Records
parse json = eitherDecode json :: Either String Records  

