/****** Object:  Table [dbo].[NBAAdvancedTable]    Script Date: 10/6/2019 3:49:21 PM ******/
DROP TABLE IF EXISTS [dbo].NBA_PlayerLog_Advanced
GO

/****** Object:  Table [dbo].[NBAAdvancedTable]    Script Date: 10/6/2019 3:49:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].NBA_PlayerLog_Advanced(
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
	[GS] [float] NULL,
	[MP] [nvarchar](100) NULL,
	[TSPer] [float] NULL,
	[eFGPer] [float] NULL,
	[ORBPer] [float] NULL,
	[DRBPer] [float] NULL,
	[TRBPer] [float] NULL,
	[ASTPer] [float] NULL,
	[STLPer] [float] NULL,
	[BLKPer] [float] NULL,
	[TOVPer] [float] NULL,
	[USGPer] [float] NULL,
	[ORTGPer] [float] NULL,
	[DRTGPer] [float] NULL,
	[GmSc] [nvarchar](100) NULL
) ON [PRIMARY]
GO


