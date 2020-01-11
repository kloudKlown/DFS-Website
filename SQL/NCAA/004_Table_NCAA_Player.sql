
DROP TABLE IF EXISTS [dbo].NCAA_Player
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].NCAA_Player(
	[PlayerName] [nvarchar](100) Primary Key NOT NULL,
	[Position] [nvarchar](100) NOT NULL,
	[Height] int NOT NULL,
	[Weight] int NOT NULL	
) ON [PRIMARY]
GO