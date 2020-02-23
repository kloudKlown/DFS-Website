import os
import sys
import re
import pyodbc as db
import datetime 
import pandas as pd

TodayString = datetime.datetime.today().strftime("%Y-%m-%d")

connection  = db.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NBA;""Trusted_Connection=yes;")
cursor = connection.cursor()                

AllStats = pd.read_sql("Select * FROM NBA_All_Stats",  con =  connection)

TodaysGames = pd.read_sql("Select * From NBA_Games where GameDate = '" + TodayString + "'", con = connection)

TodaysPlayers = pd.read_sql("Select "+
                                "DISTINCT PL.PlayerName, FL.Team, N.Position " +
                                "From NBA_FantasyLabs FL " +
                                "INNER JOIN NBAReferenceToDraftKings Map ON MAP.DK_PlayerName = FL.Player_Name " +
                                "LEFT JOIN NBA_PlayerLog PL ON PL.PlayerName = Map.NBARef_PlayerName " +
                                "LEFT JOIN NBA_Player N ON PL.PlayerName = N.PlayerName " +
                                "where FL_DateTime = '" + TodayString + "'", con = connection)

VegasLines = pd.read_sql("Select CAST(GameDate as date) Date, " +
                            " (OU/2 - Line) FVScore, FV, " +
                            " (OU/2 + Line) DogScore, " + 
                            "	CASE " +
                            "		WHEN FV = Team THEN Opp " +
                            "		ELSE Team " +
                            "	END as Dog " +
                            "From NBA_Games ORDER BY 1 DESC", con = connection)