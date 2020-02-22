 -- EXEC usp_GetTeamStatsByDate @date_ = '2019-11-3', @teamName_ = 'SAS', @oppName_ = 'TOR'
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
		CAST(AVG(PLA.USGPer) AS NUMERIC(8,2)) 'Usage',		
		CAST(AVG(PLA.DRTGPer) AS NUMERIC(8,2)) 'DefRating',	
		CAST(AVG(PLA.ORTGPer) AS NUMERIC(8,2)) 'OffRating',	
		CAST(AVG(FG) AS NUMERIC(8,2)) 'FieldGoals',
		CAST(AVG(FGA) AS NUMERIC(8,2)) 'FieldGoalsAttempted',
		CAST(AVG(Threep) AS NUMERIC(8,2)) 'ThreePointers',
		CAST(AVG(ThreepA) AS NUMERIC(8,2)) 'ThreePointersAttempted',
		CAST(AVG(AST) AS NUMERIC(8,2)) 'Assists',
		CAST(AVG(DRB) AS NUMERIC(8,2)) 'DefRebounds',
		CAST(AVG(ORB) AS NUMERIC(8,2)) 'OffRebounds',
		CAST(AVG(TRB) AS NUMERIC(8,2)) 'TotalRebounds',
		CAST(AVG(PLA.TRBPer) AS NUMERIC(8,2)) 'TotalReboundsPer',
		CAST(AVG(FT) AS NUMERIC(8,2)) 'FreeThrows',		
		CAST(AVG(BLK) AS NUMERIC(8,2)) 'Blocks',
		CAST(AVG(STL) AS NUMERIC(8,2)) 'Steals',
		CAST(AVG(PTS) AS NUMERIC(8,2)) 'Points',
		CAST(AVG(PF) AS NUMERIC(8,2)) 'Fouls',
		CAST(AVG(TOV) AS NUMERIC(8,2)) 'Turnover'
	FROM
		NBA_PlayerLog PL INNER JOIN NBA_Player P ON P.PlayerName = PL.PlayerName	
		INNER JOIN NBA_PlayerLog_Advanced PLA ON PLA.PlayerName = PL.PlayerName AND PLA.[Date] = PL.[Date]		
	WHERE 
		PL.[Date] in (SELECT DISTINCT TOP 5 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @teamName_ ORDER BY [DATE] desc )					
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
		CAST(AVG(PLA.USGPer) AS NUMERIC(8,2)) 'Usage',		
		CAST(AVG(PLA.DRTGPer) AS NUMERIC(8,2)) 'DefRating',	
		CAST(AVG(PLA.ORTGPer) AS NUMERIC(8,2)) 'OffRating',	
		CAST(AVG(FG) AS NUMERIC(8,2)) 'FieldGoals',
		CAST(AVG(FGA) AS NUMERIC(8,2)) 'FieldGoalsAttempted',
		CAST(AVG(Threep) AS NUMERIC(8,2)) 'ThreePointers',
		CAST(AVG(ThreepA) AS NUMERIC(8,2)) 'ThreePointersAttempted',
		CAST(AVG(AST) AS NUMERIC(8,2)) 'Assists',
		CAST(AVG(DRB) AS NUMERIC(8,2)) 'DefRebounds',
		CAST(AVG(ORB) AS NUMERIC(8,2)) 'OffRebounds',
		CAST(AVG(TRB) AS NUMERIC(8,2)) 'TotalRebounds',
		CAST(AVG(PLA.TRBPer) AS NUMERIC(8,2)) 'TotalReboundsPer',
		CAST(AVG(FT) AS NUMERIC(8,2)) 'FreeThrows',		
		CAST(AVG(BLK) AS NUMERIC(8,2)) 'Blocks',
		CAST(AVG(STL) AS NUMERIC(8,2)) 'Steals',
		CAST(AVG(PTS) AS NUMERIC(8,2)) 'Points',
		CAST(AVG(PF) AS NUMERIC(8,2)) 'Fouls',
		CAST(AVG(TOV) AS NUMERIC(8,2)) 'Turnover'
	FROM
		NBA_PlayerLog PL INNER JOIN NBA_Player P ON P.PlayerName = PL.PlayerName	
		INNER JOIN NBA_PlayerLog_Advanced PLA ON PLA.PlayerName = PL.PlayerName AND PLA.[Date] = PL.[Date]
	WHERE PL.[Date] in (SELECT DISTINCT TOP 5 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @oppName_ ORDER BY [DATE] desc )					
	and PL.Tm = @oppName_
	GROUP BY PL.PlayerName, PL.Tm, PL.PlayerPosition
	ORDER BY MinutesPlayed DESC

END