/****** Object:  Table [dbo].[NBA_FantasyLabs]    Script Date: 2019-11-17 10:48:11 PM ******/
DROP TABLE IF EXISTS [dbo].[NBA_FantasyLabs]
GO


CREATE TABLE [dbo].[NBA_FantasyLabs](
	[Player_Name] [nvarchar](100) NULL,
	[ID] [nvarchar](100) NULL,
	[Salary] [nvarchar](100) NULL,
	[Pos] [nvarchar](100) NULL,
	[Roster_Order] [nvarchar](100) NULL,
	[Team] [nvarchar](100) NULL,
	[Opp] [nvarchar](100) NULL,
	[FL_DateTime] [datetime] NULL,
	[Proj_FP] [nvarchar](100) NULL,
	[Rating] [nvarchar](100) NULL,
	[Actual_FP] [nvarchar](100) NULL,
	[IsSelected] [bit] NULL
) ON [PRIMARY]
GO


