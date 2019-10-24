DROP VIEW [dbo].[NBA_All_Stats]
GO

CREATE VIEW 
	[dbo].[NBA_All_Stats] AS
SELECT
	DISTINCT
	NBA.PlayerName,
	P.Position,
	NBA.Date,
	NBA.Tm Team,
	NBA.blank,
	NBA.Opp,
	NBA.blank2,
	NBA.MP,
	FG,
	FGA,
	FGper,
	ThreeP,
	ThreePA,
	ThreePper,
	FT,
	FTA,
	FTper,
	ORB,
	DRB,
	TRB,
	AST,
	STL,
	BLK,
	TOV,
	PF,
	PTS,
	NBA.GmSc,
	TSPer,
	eFGPer,
	ORBPer,
	DRBPer,
	TRBPer,
	ASTPer,
	STLPer,
	BLKPer,
	TOVPer,
	USGPer,
	ORTGPer,
	DRTGPer
FROM 
	NBA_PlayerLog NBA
	INNER JOIN NBA_PlayerLog_Advanced  PLA ON PLA.PlayerName = NBA.PlayerName AND PLA.[Date] = NBA.[Date]	
	INNER JOIN NBA_Player P ON NBA.PlayerName = P.PlayerName
WHERE
	NBA.[Date] > '2018-07-01'
GO
