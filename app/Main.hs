module Main where

import HTTP 
import Parse
import Database

main :: IO ()
main = do
    let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    print "Downloading..."
    json <- download url
    print "Parsing..."
    case (parse json) of 
        Left err -> print err
        Right recs -> do
            print "Saving on DB..."
            conn <- initialiseDB
            saveRecords (records recs) conn
    print "Done!"