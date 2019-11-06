DROP INDEX IF EXISTS CIX_NBAShotChart_PlayerTeam_GameDate ON NBAShotChart
GO
CREATE NONCLUSTERED INDEX CIX_NBAShotChart_PlayerTeam_GameDate
ON [dbo].[NBAShotChart] ([PlayerTeam],[GameDate])
INCLUDE ([PlayerName],[Shot],[ShotZone],[ShotDistanceX],[ShotDistanceY])
GO

DROP INDEX IF EXISTS CIX_NBA_PlayerLog_PlayerName_DateFT ON NBA_PlayerLog
GO
CREATE NONCLUSTERED INDEX CIX_NBA_PlayerLog_PlayerName_DateFT
ON [dbo].[NBA_PlayerLog] ([PlayerName])
INCLUDE ([Date],[FT])
GO


DROP INDEX IF EXISTS CIX_NBA_PlayerLog_PlayerName_DateTm ON NBA_PlayerLog
GO
CREATE NONCLUSTERED INDEX CIX_NBA_PlayerLog_PlayerName_DateTm
ON [dbo].[NBA_PlayerLog] ([PlayerName])
INCLUDE ([Date],[Tm])
GO