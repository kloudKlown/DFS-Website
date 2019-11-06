/****** Object:  Table [dbo].[NBA_PlayerLog]    Script Date: 11/5/2019 7:22:07 PM ******/
DROP TABLE IF EXISTS [dbo].[NHL_PlayerLog]
GO

/****** Object:  Table [dbo].[NBA_PlayerLog]    Script Date: 11/5/2019 7:22:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NHL_PlayerLog](
	[PlayerName] [nvarchar](100) NULL,
	[PlayerPosition] [nvarchar](4) NULL,	
	[GID] INT NULL,
	[GameDate] [datetime] NULL,
	[G] [nvarchar] (3) NULL,
	[Age] [nvarchar](100) NULL,
	[Team] [nvarchar](3) NULL,
	[HW] [nvarchar](10) NULL,
	[Opp] [nvarchar](3) NULL,
	[WinLoss] [nvarchar](10) NULL,
	[Goals] INT NULL,
	[Assists] INT NULL,
	[Points] INT NULL,
	[PlusMinus] INT NULL,
	[Penalties] INT NULL,
	[EGoals] INT NULL,
	[PPGoals] INT NULL,
	[SHGoals] INT NULL,
	[GWGoals] INT NULL,
	[EVAssits] INT NULL,
	[PPAssits] INT NULL,
	[SHAssits] INT NULL,
	[ShotsOnGoal] INT NULL,
	[ShootingPer] NUMERIC (5, 2) NULL,
	[Shits] INT NULL,
	[MP] INT NULL,
	[Hits] INT NULL,
	[Blocks] INT NULL,
	[FaceOffWins] INT NULL,
	[FaceOffLoss] INT NULL,
	[FaceOffPer] NUMERIC (5, 2) NULL
) ON [PRIMARY]
GO


