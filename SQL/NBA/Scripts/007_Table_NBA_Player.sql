/****** Object:  Table [dbo].[NBATableData]    Script Date: 10/6/2019 3:45:04 PM ******/
DROP TABLE IF EXISTS [dbo].[NBA_Player]
GO

/****** Object:  Table [dbo].[NBATableData]    Script Date: 10/6/2019 3:45:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NBA_Player](
	[PlayerName] [nvarchar](100) Primary Key NOT NULL,
	[Position] [nvarchar](100) NOT NULL,
	[Height] int NOT NULL,
	[Weight] int NOT NULL	
) ON [PRIMARY]
GO