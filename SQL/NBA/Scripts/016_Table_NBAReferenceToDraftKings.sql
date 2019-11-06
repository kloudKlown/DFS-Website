
/****** Object:  Table [dbo].[NBAReferenceToShotChartMap]    Script Date: 10/16/2019 9:01:01 PM ******/
DROP TABLE IF EXISTS [dbo].[NBAReferenceToDraftKings]
GO

/****** Object:  Table [dbo].[NBAReferenceToShotChartMap]    Script Date: 10/16/2019 9:01:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NBAReferenceToDraftKings](
	[NBARef_PlayerName] [nvarchar](100) NOT NULL,
	[DK_PlayerName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_NBAReferenceToDraftKings_PlayerName] PRIMARY KEY NONCLUSTERED 
(
	[NBARef_PlayerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


