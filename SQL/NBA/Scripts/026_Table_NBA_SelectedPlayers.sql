DROP TABLE IF EXISTS [NBA_SelectedPlayers]
GO

/****** Object:  Table [dbo].[NBA_Games]    Script Date: 2020-03-01 6:14:29 PM ******/

CREATE TABLE [dbo].[NBA_SelectedPlayers](
	[ID] int IDENTITY(1,1) NOT NULL,
	[GameDate] [datetime] NOT NULL,
	[Team] [nvarchar](3) NOT NULL,
	[Name] [nvarchar] (100) NOT NULL
) ON [PRIMARY]
GO


