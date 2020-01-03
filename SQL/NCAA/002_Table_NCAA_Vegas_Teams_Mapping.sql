DROP TABLE IF EXISTS NCAA_Vegas_Teams_Mapping
GO


CREATE TABLE [dbo].[NCAA_Vegas_Teams_Mapping](
	[NCAA_Team] [nvarchar](100) NOT NULL,
	[Vegas_Team] [nvarchar](100) NOT NULL,
 ) ON [PRIMARY]
GO



