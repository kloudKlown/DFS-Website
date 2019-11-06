DROP VIEW IF EXISTS NBA_Consolidated_View
GO

CREATE VIEW 
	NBA_Consolidated_View AS
SELECT
	NBA.PlayerName,
	NBA.PlayerPosition,
	NBA.Date,
	NBA.Tm Team,
	NBA.Opp,
	NBA.MP,
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
	GmSc,
	QuarterNo,
	QMinute,
	QSecond,
	Shot,
	ShotType,
	ShotPoints,
	ShotZone,
	ShotPosition,
	ShotDistanceDesc,
	ShotDistance,
	ShotDistanceX,
	ShotDistanceY,
	UnknownX,
	UnknownY
FROM 
	NBA_PlayerLog NBA
	INNER JOIN NBAReferenceToShotChartMap Ref ON Ref.NBARef_PlayerName = NBA.PlayerName
	INNER JOIN NBAShotChart Shot  ON Ref.ShotChart_PlayerName = Shot.PlayerName and Shot.GameDate = NBA.Date
GO


SELECT * FROM NBA_Consolidated_View;