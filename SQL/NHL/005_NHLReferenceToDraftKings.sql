USE [NHL]
GO

/****** Object:  Table [dbo].[NBAReferenceToDraftKings]    Script Date: 2019-12-08 4:50:48 AM ******/
DROP TABLE IF EXISTS [dbo].[NHLReferenceToDraftKings]
GO

/****** Object:  Table [dbo].[NBAReferenceToDraftKings]    Script Date: 2019-12-08 4:50:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].NHLReferenceToDraftKings(	
	[DK_PlayerName] [nvarchar](100) NOT NULL,
	[NHLRef_PlayerName] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO


