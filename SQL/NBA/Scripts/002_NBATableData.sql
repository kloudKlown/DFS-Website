/****** Object:  Table [dbo].[NBATableData]    Script Date: 10/5/2019 4:15:55 PM ******/
DROP TABLE IF EXISTS [dbo].[NBATableData]
GO

/****** Object:  Table [dbo].[NBATableData]    Script Date: 10/5/2019 4:15:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NBATableData](
	[PlayerName] [nvarchar](100) NULL,
	[PlayerPosition] [nvarchar](100) NULL,
	[Rk] [nvarchar](100) NULL,
	[G] [nvarchar](100) NULL,
	[Date] [datetime] NULL,
	[Age] [nvarchar](100) NULL,
	[Tm] [nvarchar](100) NULL,
	[blank] [nvarchar](100) NULL,
	[Opp] [nvarchar](100) NULL,
	[blank2] [nvarchar](100) NULL,
	[GS] [nvarchar](100) NULL,
	[MP] [nvarchar](100) NULL,
	[FG] [float] NULL,
	[FGA] [float] NULL,
	[FGper] [nvarchar](100) NULL,
	[ThreeP] [float] NULL,
	[ThreePA] [float] NULL,
	[ThreePper] [nvarchar](100) NULL,
	[FT] [float] NULL,
	[FTA] [float] NULL,
	[FTper] [nvarchar](100) NULL,
	[ORB] [float] NULL,
	[DRB] [float] NULL,
	[TRB] [float] NULL,
	[AST] [float] NULL,
	[STL] [float] NULL,
	[BLK] [float] NULL,
	[TOV] [float] NULL,
	[PF] [float] NULL,
	[PTS] [float] NULL,
	[GmSc] [nvarchar](100) NULL,
	[plusMinus] [nvarchar](100) NULL
) ON [PRIMARY]
GO


