library(odbc)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "localhost",
                 Database = "NHL",
                 Trusted_Connection = "True",
                 Port = 1433)

NHLSavantPlayer = dbSendQuery(con, "exec usp_GetPlayerLogs")
NHLTableData = dbFetch(NHLSavantPlayer)
dbClearResult(NHLSavantPlayer)
rm(NHLSavantPlayer)


NHLSavantGoalie = dbSendQuery(con, "Select * From NHL_PlayerLog_Goalie")
NHLGoalieData = dbFetch(NHLSavantGoalie)
dbClearResult(NHLSavantGoalie)
rm(NHLSavantGoalie)