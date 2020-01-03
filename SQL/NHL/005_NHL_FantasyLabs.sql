USE NHL
GO

/****** Object:  Table [dbo].[NBA_FantasyLabs]    Script Date: 2019-12-07 6:28:40 PM ******/
DROP TABLE IF EXISTS [dbo].NHL_FantasyLabs
GO

/****** Object:  Table [dbo].[NBA_FantasyLabs]    Script Date: 2019-12-07 6:28:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].NHL_FantasyLabs(
	[Player_Name] [nvarchar](100) NULL,	
	[Salary] NUMERIC(10,1) NULL,	
	[Pos] [nvarchar](1) NULL,
	[Team] [nvarchar](3) NULL,
	[Opp] [nvarchar](3) NULL,
	[FL_DateTime] [nvarchar](20) NULL,	
	vegasTotal [nvarchar](10) NULL,
	vegasT [nvarchar](10) NULL,
	Line [nvarchar](10) NULL,
	[PowerPlay] [nvarchar](10) NULL,
) ON [PRIMARY]
GO


