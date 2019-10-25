library(odbc)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "localhost",
                 Database = "NBA",
                 Trusted_Connection = "True",
                 Port = 1433)

BBSavantPlayer = dbSendQuery(con, "Select * From [NBA_All_Stats]")
NBATableData = dbFetch(BBSavantPlayer)
dbClearResult(BBSavantPlayer)

BBSavantPlayer = dbSendQuery(con, paste("Select * From NBA_Games where GameDate = '", Sys.Date() , "'"))
TodaysGames = dbFetch(BBSavantPlayer)
dbClearResult(BBSavantPlayer)


BBSavantPlayer = dbSendQuery(con, paste("Select ",
                    	"DISTINCT PL.PlayerName, FL.Team, N.Position ",
                    "From NBA_FantasyLabs FL ",
                    "INNER JOIN NBAReferenceToDraftKings Map ON MAP.DK_PlayerName = FL.Player_Name ",
                    "LEFT JOIN NBA_PlayerLog PL ON PL.PlayerName = Map.NBARef_PlayerName",
                    "LEFT JOIN NBA_Player N ON PL.PlayerName = N.PlayerName",
                    "where FL_DateTime = '", Sys.Date() ,"'"))
TodaysPlayers = dbFetch(BBSavantPlayer)
dbClearResult(BBSavantPlayer)
                             