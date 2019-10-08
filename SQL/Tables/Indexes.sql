DROP INDEX IF EXISTS CIX_NBAShotChart_PlayerTeam_GameDate ON NBAShotChart
GO

CREATE NONCLUSTERED INDEX CIX_NBAShotChart_PlayerTeam_GameDate
ON [dbo].[NBAShotChart] ([PlayerTeam],[GameDate])
INCLUDE ([PlayerName],[Shot],[ShotZone],[ShotDistanceX],[ShotDistanceY])
GO


DROP INDEX IF EXISTS NCIX_NBATableData_PlayerName ON NBATableData
GO

CREATE NONCLUSTERED INDEX NCIX_NBATableData_PlayerName
ON [dbo].[NBATableData] ([PlayerName])
INCLUDE ([Date],[FT])
GO