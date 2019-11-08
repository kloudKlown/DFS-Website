library(odbc)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "localhost",
                 Database = "NHL",
                 Trusted_Connection = "True",
                 Port = 1433)

NHLSavantPlayer = dbSendQuery(con, "Select * From [NHL_PlayerLog] Where GameDate > '2017-10-01'")
NHLTableData = dbFetch(NHLSavantPlayer)
dbClearResult(NHLSavantPlayer)
