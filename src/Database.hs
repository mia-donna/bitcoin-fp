{-# LANGUAGE BlockArguments #-}
module Database 
    (initialiseDB,
    saveRecords
    ) where

import Parse
import Database.HDBC
import Database.HDBC.Sqlite3

initialiseDB :: IO Connection 
initialiseDB = 
    do 
        conn <- connectSqlite3 "bitcoin-fp.sqlite"
        run conn "CREATE TABLE IF NOT EXISTS records (\
             \code VARCHAR(40) NOT NULL, \
             \symbol VARCHAR(40) NOT NULL, \
             \rate VARCHAR(40) NOT NULL, \
             \description VARCHAR(40) NOT NULL \
             \)" []
        commit conn 
        return conn

recordToSqlValues :: Record -> [SqlValue] 
recordToSqlValues record = [
       toSql $ code record,
       toSql $ symbol record,
       toSql $ rate record,
       toSql $ description record
    ]    

prepareInsertRecordStmt :: Connection -> IO Statement
prepareInsertRecordStmt conn = prepare conn "INSERT INTO records VALUES (?,?,?,?)"

saveRecords :: [Record] -> Connection -> IO ()
saveRecords records conn = do
     stmt <- prepareInsertRecordStmt conn 
     executeMany stmt (map recordToSqlValues records) 
     commit conn 