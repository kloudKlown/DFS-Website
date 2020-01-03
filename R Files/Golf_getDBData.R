library(odbc)
GolfConnection <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "localhost",
                 Database = "Golf",
                 Trusted_Connection = "True",
                 Port = 1433)

tempCollector = dbSendQuery(GolfConnection, "Select * From Golf_Player")
GolfPlayer = dbFetch(tempCollector)
dbClearResult(tempCollector)
rm(tempCollector)


tempCollector = dbSendQuery(GolfConnection, "Select * From Golf_PlayerLog")
GolfPlayerLogs = dbFetch(tempCollector)
dbClearResult(tempCollector)
rm(tempCollector)


tempCollector = dbSendQuery(GolfConnection, "Select * From Golf_PlayerStats")
GolfPlayerTourStats = dbFetch(tempCollector)
dbClearResult(tempCollector)
rm(tempCollector)

rm(GolfConnection)
