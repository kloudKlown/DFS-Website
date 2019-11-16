 -- EXEC usp_GetTeamStatsCurrent @date_ = '2019-11-3', @teamName_ = 'SAS', @oppName_ = 'TOR'
DROP PROCEDURE IF EXISTS usp_GetTeamStatsCurrent
GO

CREATE PROCEDURE usp_GetTeamStatsCurrent
(
	@date_ DateTime,
	@teamName_ nvarchar(3),
	@oppName_ nvarchar(3)
)
AS
BEGIN

	SELECT
		DISTINCT
			PL.PlayerName, 
			@teamName_ Team,		
			FI.PlayerPosition,
			AVG(N.Height) Height,
			AVG(N.[Weight]) [Weight],
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
			CAST(AVG(TOV) AS NUMERIC(8,2)) 'Turnover'FROM
		NBA_FantasyLabs FL
		LEFT JOIN NBAReferenceToDraftKings DK ON DK.DK_PlayerName = FL.Player_Name
		INNER JOIN NBA_PlayerLog PL ON PL.PlayerName = DK.NBARef_PlayerName
		INNER JOIN NBA_PlayerLog_Advanced PLA ON PLA.PlayerName = PL.PlayerName
		INNER JOIN NBA_Player N ON N.PlayerName = PLA.PlayerName
		INNER JOIN NBA_PlayerLog_Advanced FI ON Fi.PlayerName = PL.PlayerName
	WHERE
		FL_DateTime = @date_
		AND	PL.[Date] in (SELECT DISTINCT TOP 20 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @teamName_ ORDER BY [DATE] desc )					
		AND FI.[Date] in (SELECT DISTINCT TOP 6 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @teamName_ ORDER BY [DATE] desc )
		AND FL.Team = @teamName_
		GROUP BY PL.PlayerName, FI.PlayerPosition
		ORDER BY MinutesPlayed DESC

	SELECT
		DISTINCT
			PL.PlayerName, 
			@oppName_ Team,		
			FI.PlayerPosition,
			AVG(N.Height) Height,
			AVG(N.[Weight]) [Weight],
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
			CAST(AVG(TOV) AS NUMERIC(8,2)) 'Turnover'FROM
		NBA_FantasyLabs FL
		LEFT JOIN NBAReferenceToDraftKings DK ON DK.DK_PlayerName = FL.Player_Name
		INNER JOIN NBA_PlayerLog PL ON PL.PlayerName = DK.NBARef_PlayerName
		INNER JOIN NBA_PlayerLog_Advanced PLA ON PLA.PlayerName = PL.PlayerName
		INNER JOIN NBA_Player N ON N.PlayerName = PLA.PlayerName
		INNER JOIN NBA_PlayerLog_Advanced FI ON FI.PlayerName = PL.PlayerName
	WHERE
		FL_DateTime = @date_
		AND	PL.[Date] in (SELECT DISTINCT TOP 20 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @oppName_ ORDER BY [DATE] desc )					
		AND FI.[Date] in (SELECT DISTINCT TOP 6 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @oppName_ ORDER BY [DATE] desc )
		AND FL.Team = @oppName_
		GROUP BY PL.PlayerName, FI.PlayerPosition
		ORDER BY MinutesPlayed DESC

END