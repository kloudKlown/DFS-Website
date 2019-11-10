/****** Object:  Table [dbo].[NBA_Games]    Script Date: 11/9/2019 3:09:50 PM ******/
DROP TABLE IF EXISTS [dbo].[NHL_Games]
GO

/****** Object:  Table [dbo].[NBA_Games]    Script Date: 11/9/2019 3:09:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NHL_Games](
	[GameDate] [datetime] NOT NULL,
	[Team] [nvarchar](100) NOT NULL,
	[Opp] [nvarchar](100) NOT NULL,
	[Line] [int] NOT NULL,
	[OU] [int] NOT NULL,
	[FV] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO


