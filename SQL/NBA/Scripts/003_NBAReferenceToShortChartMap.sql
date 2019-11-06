ALTER TABLE NBAReferenceToShotChartMap DROP CONSTRAINT IF EXISTS PK_NBAReferenceToShotChartMap_PlayerName;
DROP TABLE IF EXISTS [NBAReferenceToShotChartMap];

CREATE TABLE [dbo].[NBAReferenceToShotChartMap](
	[ShotChart_PlayerName] [nvarchar](100)NOT NULL,
	[NBARef_PlayerName] [nvarchar](100) NOT NULL	
	CONSTRAINT PK_NBAReferenceToShotChartMap_PlayerName PRIMARY KEY NONCLUSTERED (NBARef_PlayerName)
) ON [PRIMARY]
GO


