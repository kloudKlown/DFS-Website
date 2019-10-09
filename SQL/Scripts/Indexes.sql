DROP INDEX IF EXISTS CIX_NBAShotChart_PlayerTeam_GameDate ON NBAShotChart
GO

CREATE NONCLUSTERED INDEX CIX_NBAShotChart_PlayerTeam_GameDate
ON [dbo].[NBAShotChart] ([PlayerTeam],[GameDate])
INCLUDE ([PlayerName],[Shot],[ShotZone],[ShotDistanceX],[ShotDistanceY])
GO