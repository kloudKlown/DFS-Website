
DROP TABLE IF EXISTS [dbo].[NHL_Player]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NHL_Player](
	[PlayerName] [nvarchar](100) NOT NULL,
	[PlayerPosition] [nvarchar](100) NOT NULL,
	[Height] NUMERIC(3, 0) NOT NULL,
	[Weight] NUMERIC(3, 0) NOT NULL
) ON [PRIMARY]
GO


