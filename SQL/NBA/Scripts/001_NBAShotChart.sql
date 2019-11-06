
/****** Object:  Table [dbo].[NBAShotChart]    Script Date: 10/5/2019 4:12:55 PM ******/
DROP TABLE IF EXISTS [dbo].[NBAShotChart]
GO


SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NBAShotChart](
	[SortChart] [nvarchar](100) NULL,
	[BoxScore] [nvarchar](100) NULL,
	[ShotID] [int] NULL,
	[PlayerID] [int] NULL,
	[PlayerName] [nvarchar](100) NULL,
	[UnknownID] [numeric](18, 0) NULL,
	[PlayerTeam] [nvarchar](100) NULL,
	[QuarterNo] [int] NULL,
	[QMinute] [int] NULL,
	[QSecond] [int] NULL,
	[Shot] [nvarchar](100) NULL,
	[ShotType] [nvarchar](100) NULL,
	[ShotPoints] [nvarchar](100) NULL,
	[ShotZone] [nvarchar](100) NULL,
	[ShotPosition] [nvarchar](100) NULL,
	[ShotDistanceDesc] [nvarchar](100) NULL,
	[ShotDistance] [int] NULL,
	[ShotDistanceX] [int] NULL,
	[ShotDistanceY] [int] NULL,
	[UnknownX] [int] NULL,
	[UnknownY] [int] NULL,
	[GameDate] [datetime] NULL,
	[HomeTeam] [nvarchar](100) NULL,
	[AwayTeam] [nvarchar](100) NULL
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX CIX_NBAShotChart_PlayerTeam_GameDate
ON [dbo].[NBAShotChart] ([PlayerTeam],[GameDate])
INCLUDE ([PlayerName],[Shot],[ShotZone],[ShotDistanceX],[ShotDistanceY])
GO



