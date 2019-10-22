 -- EXEC usp_GetTeamStatsByDate @date_ = '2019-10-17', @teamName_ = 'MIA', @oppName_ = 'ORL'
DROP PROCEDURE IF EXISTS usp_GetTeamStatsByDate
GO

CREATE PROCEDURE usp_GetTeamStatsByDate
(
	@date_ DateTime,
	@teamName_ nvarchar(3),
	@oppName_ nvarchar(3)
)
AS
BEGIN
	Select
		DISTINCT
		PL.PlayerName, 
		PL.Tm Team,		
		PL.PlayerPosition,
		AVG(P.Height) Height,
		AVG(P.[Weight]) [Weight],
		TIMEFROMPARTS(0, ROUND(AVG(PL.MP/60), 0, 0), (AVG(CAST(PL.MP as INT)) - ROUND(AVG(CAST(PL.MP as INT))/60, 0, 0)*60), 0, 0) MinutesPlayed,
		AVG(PLA.USGPer) 'Usage',		
		AVG(PLA.DRTGPer) 'DefRating',	
		AVG(PLA.ORTGPer) 'OffRating',	
		AVG(FG) 'FieldGoals',
		AVG(FGA) 'FieldGoalsAttempted',
		AVG(Threep) 'ThreePointers',
		AVG(ThreepA) 'ThreePointersAttempted',
		AVG(AST) 'Assists',
		AVG(DRB) 'DefRebounds',
		AVG(ORB) 'OffRebounds',
		AVG(TRB) 'TotalRebounds',
		AVG(PLA.TRBPer) 'TotalReboundsPer',
		AVG(FT) 'FreeThrows',		
		AVG(BLK) 'Blocks',
		AVG(STL) 'Steals',
		AVG(PTS) 'Points',
		AVG(PF) 'Fouls',
		AVG(TOV) 'Turnover'
	FROM
		NBA_PlayerLog PL INNER JOIN NBA_Player P ON P.PlayerName = PL.PlayerName	
		INNER JOIN NBA_PlayerLog_Advanced PLA ON PLA.PlayerName = PL.PlayerName AND PLA.[Date] = PL.[Date]
	WHERE PL.[Date] in (SELECT TOP 5 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @teamName_ ORDER BY [DATE] desc )					
	and PL.Tm = @teamName_
	GROUP BY PL.PlayerName, PL.Tm, PL.PlayerPosition
	ORDER BY MinutesPlayed DESC

	Select
		DISTINCT
		PL.PlayerName, 
		PL.Tm Team,		
		PL.PlayerPosition,
		AVG(P.Height) Height,
		AVG(P.[Weight]) [Weight],
		TIMEFROMPARTS(0, ROUND(AVG(PL.MP/60), 0, 0), (AVG(CAST(PL.MP as INT)) - ROUND(AVG(CAST(PL.MP as INT))/60, 0, 0)*60), 0, 0) MinutesPlayed,
		AVG(PLA.USGPer) 'Usage',		
		AVG(PLA.DRTGPer) 'DefRating',	
		AVG(PLA.ORTGPer) 'OffRating',	
		AVG(FG) 'FieldGoals',
		AVG(FGA) 'FieldGoalsAttempted',
		AVG(Threep) 'ThreePointers',
		AVG(ThreepA) 'ThreePointersAttempted',
		AVG(AST) 'Assists',
		AVG(DRB) 'DefRebounds',
		AVG(ORB) 'OffRebounds',
		AVG(TRB) 'TotalRebounds',
		AVG(PLA.TRBPer) 'TotalReboundsPer',
		AVG(FT) 'FreeThrows',		
		AVG(BLK) 'Blocks',
		AVG(STL) 'Steals',
		AVG(PTS) 'Points',
		AVG(PF) 'Fouls',
		AVG(TOV) 'Turnover'

	FROM
		NBA_PlayerLog PL INNER JOIN NBA_Player P ON P.PlayerName = PL.PlayerName	
		INNER JOIN NBA_PlayerLog_Advanced PLA ON PLA.PlayerName = PL.PlayerName AND PLA.[Date] = PL.[Date]
	WHERE PL.[Date] in (SELECT TOP 5 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @oppName_ ORDER BY [DATE] desc )					
	and PL.Tm = @oppName_
	GROUP BY PL.PlayerName, PL.Tm, PL.PlayerPosition
	ORDER BY MinutesPlayed DESC

END