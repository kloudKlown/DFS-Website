/****** Object:  Table [dbo].[[NCAA_PlayerLog]]    Script Date: 2019-11-19 8:25:30 PM ******/
DROP TABLE IF EXISTS [dbo].[NCAA_PlayerLog]
GO

/****** Object:  Table [dbo].[[NCAA_PlayerLog]]    Script Date: 2019-11-19 8:25:30 PM ******/
CREATE TABLE [dbo].[NCAA_PlayerLog](
	[PlayerName] [nvarchar](100) NULL,
	[PlayerPosition] [nvarchar](100) NULL,
	[Rk] int NULL,	
	[Date] [datetime] NULL,
	[School] [nvarchar](100) NULL,
	[blank] [nvarchar] NULL,
	[Opponent] [nvarchar](100) NULL,
	[Type] [nvarchar](100) NULL,
	[blank2] [nvarchar](100) NULL,
	[GS] int NULL,
	[MP] int NULL,
	[FG] [float] NULL,
	[FGA] [float] NULL,
	[FGper] [float] NULL,
	[TwoP] [float] NULL,
	[TwoPA] [float] NULL,
	[TwoPper] [float] NULL,
	[ThreeP] [float] NULL,
	[ThreePA] [float] NULL,
	[ThreePper] [float] NULL,
	[FT] [float] NULL,
	[FTA] [float] NULL,
	[FTper] [float] NULL,
	[ORB] [float] NULL,
	[DRB] [float] NULL,
	[TRB] [float] NULL,
	[AST] [float] NULL,
	[STL] [float] NULL,
	[BLK] [float] NULL,
	[TOV] [float] NULL,
	[PF] [float] NULL,
	[PTS] [float] NULL
) ON [PRIMARY]
GO


