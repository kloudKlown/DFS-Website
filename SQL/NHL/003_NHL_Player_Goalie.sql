
DROP TABLE IF EXISTS [dbo].[NHL_PlayerLog_Goalie]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NHL_PlayerLog_Goalie](
	[PlayerName] [nvarchar](100) NOT NULL,
	[PlayerPosition] [nvarchar](100) NOT NULL,
	[GID] INT NULL,
	[GameDate] [datetime] NULL,
	[G] [nvarchar] (3) NULL,
	[Age] [nvarchar](100) NULL,
	[Team] [nvarchar](3) NULL,
	[HW] [nvarchar](10) NULL,
	[Opp] [nvarchar](3) NULL,
	[WinLoss] [nvarchar](10) NULL,
	[Decision] [nvarchar](10) NULL,
	[GoalsAgainst] INT NULL,
	[ShotsAgainst] INT NULL,
	[Saves] INT NULL,
	[SavePercentage] NUMERIC (12, 4) NULL,
	[ShoutOuts] INT NULL,
	[Penalties] INT NULL,
	[MP] INT NULL
) ON [PRIMARY]
GO


