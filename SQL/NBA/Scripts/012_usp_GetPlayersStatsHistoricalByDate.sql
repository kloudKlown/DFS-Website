/*
 Get players stats for give time interval
*/

-- exec usp_GetPlayersStatsHistoricalByDate @gameDate_ = '2018-12-1', @daysBefore_ = 10
DROP PROCEDURE IF EXISTS usp_GetPlayersStatsHistoricalByDate
GO

CREATE PROCEDURE usp_GetPlayersStatsHistoricalByDate
(
	@gameDate_ DATETIME,
	@daysBefore_ INT = 0
)
AS
BEGIN
	SELECT	
		N.PlayerName [Name],
		Position,
		Height,
		[Weight],
		P.Tm Team,
		P.[date] GameDate,
		P.Opp Opposition,

		CASE 
			WHEN P.blank = '@'
				THEN 0
			ELSE	
				1
		END as Home,
		CASE
			WHEN P.blank2 like 'L%'
				THEN 
					CAST(SUBSTRING(P.blank2, 2, len(P.blank2)-1) as int) * -1
			ELSE
					CAST(SUBSTRING(P.blank2, 2, len(P.blank2)-1) as int)
		END as WinLoss,
		TIMEFROMPARTS(0, ROUND(P.MP/60, 0, 0), (P.MP - ROUND(P.MP/60, 0, 0)*60), 0, 0) MinutesPlayed,
		P.FG FieldGoal,		
		P.FGA FieldGoalAttempted,	
		CASE 
			WHEN P.FGper is NULL
				THEN '0'
			ELSE
				CAST(P.FGper as float)
		END as FieldGoalPercentage,
		P.FT FreeThrow,		
		P.FTA FreeThrowAttempted,
		CASE 
			WHEN P.FTper is NULL
				THEN '0'
			ELSE
				CAST(P.FTper as float)
		END as FreeThrowPercentage,
		P.ThreeP ThreePointer,		
		P.ThreePA ThreePointerAttempted,		
		CASE 
			WHEN P.ThreePper is NULL
				THEN '0'
			ELSE
				CAST(P.ThreePper as float)
		END as ThreePointerPercentage,
		P.ORB OffensiveRebound,		
		P.DRB DefensiveRebound,
		P.TRB TotalRebound,
		P.AST Assists,
		P.BLK Blocks,
		P.STL Steals,
		P.TOV TurnOvers,
		P.PF PersonalFouls,
		P.PTS PointsScored
	FROM
		NBA_Player N (NOLOCK)
		INNER JOIN NBA_PlayerLog P ON P.PlayerName = N.PlayerName	
		WHERE			
			P.[date] < @gameDate_ and P.[Date] >= DATEADD(DD, -@daysBefore_, @gameDate_)
	ORDER BY GameDate asc, Name asc
END

