DROP INDEX IF EXISTS CIX_NBAShotChart_PlayerTeam_GameDate ON NBAShotChart
GO

CREATE NONCLUSTERED INDEX CIX_NBAShotChart_PlayerTeam_GameDate
ON [dbo].[NBAShotChart] ([PlayerTeam],[GameDate])
INCLUDE ([PlayerName],[Shot],[ShotZone],[ShotDistanceX],[ShotDistanceY])
GO

DROP INDEX IF EXISTS CIX_NBA_PlayerLog_Date ON NBA_PlayerLog
GO 

CREATE NONCLUSTERED INDEX CIX_NBA_PlayerLog_Date
ON [dbo].[NBA_PlayerLog] ([Date])
GO


DROP INDEX IF EXISTS CIX_NBA_FantasyLabs_Team_DateTime ON [NBA_FantasyLabs]
GO 

CREATE NONCLUSTERED INDEX CIX_NBA_FantasyLabs_Team_DateTime
ON [dbo].[NBA_FantasyLabs] ([Team],[FL_DateTime])
INCLUDE ([Player_Name])

DROP INDEX IF EXISTS CIX_NBA_PlayerLog_MultipleStats ON [NBA_PlayerLog]
GO 

CREATE NONCLUSTERED INDEX CIX_NBA_PlayerLog_MultipleStats
ON [dbo].[NBA_PlayerLog] ([Date])
INCLUDE ([PlayerName],[MP],[FG],[FGA],[ThreeP],[ThreePA],[FT],[ORB],[DRB],[TRB],[AST],[STL],[BLK],[TOV],[PF],[PTS])
GO