-- EXEC usp_GetZoneStats_Team  @team_ = 'LAL'

DROP PROCEDURE IF EXISTS usp_GetZoneStats_Team
GO

CREATE PROCEDURE usp_GetZoneStats_Team
(
	@team_ NVARCHAR(100) NULL
)
AS
BEGIN

	SELECT 
	A.GameDate, A.PlayerName, A.PlayerTeam Team,  A.Opp Opp, A.PlayerPosition Position, CAST(count(A.Shot) as int) Totals, 
	CAST(A.FreeThrows as int) FreeThrows, A.Zones, A.Shot
	FROM
	(
	Select 
			Shot.*,
			CASE
				WHEN ShotZone = 'Above The Break 3' and ShotPosition = 'Right Side Center(RC)'
					THEN 'Right 3'
				WHEN ShotZone = 'Above The Break 3' and ShotPosition = 'Center(C)'
					THEN 'Center 3'
				WHEN ShotPosition = 'Back Court(BC)'
					THEN 'Back 3'
				WHEN ShotZone = 'Above The Break 3' and ShotPosition = 'Left Side Center(LC)'
					THEN 'Left 3'
				WHEN ShotZone = 'Left Corner 3' and ShotPosition = 'Left Side(L)'
					THEN 'Left Corner 3'
				WHEN ShotZone = 'Right Corner 3' and ShotPosition = 'Right Side(R)'
					THEN 'Right Corner 3'
				WHEN ShotZone = 'Mid-Range' and ShotPosition in ('Left Side Center(LC)', 'Left Side(L) ')
					THEN 'Left 2'
				WHEN ShotZone = 'Mid-Range' and ShotPosition in ('Right Side Center(RC)', 'Right Side(R)')
					THEN 'Right 2'
				WHEN ShotZone = 'Mid-Range' and ShotPosition = 'Center(C)'
					THEN 'Center 2'
				--WHEN ShotDistanceX > -248 and ShotDistanceX <= 0 and ShotDistanceY > -248 and ShotDistanceY < 130 and ShotZone != 'In The Paint (Non-RA)' and ShotZone != 'Restricted Area'
				--	THEN 'Zone1'
				--WHEN ShotDistanceX > 0 and ShotDistanceX < 250 and ShotDistanceY > -248 and ShotDistanceY < 130 and ShotZone != 'In The Paint (Non-RA)' and ShotZone != 'Restricted Area'
				--	THEN 'Zone2'
				--WHEN ShotDistanceX > -248 and ShotDistanceX <= 0 and ShotDistanceY > 130 and ShotDistanceY < 852 and ShotZone != 'In The Paint (Non-RA)' and ShotZone != 'Restricted Area'
				--	THEN 'Zone3'
				--WHEN ShotDistanceX > 0 and ShotDistanceX < 250 and ShotDistanceY > 130 and ShotDistanceY < 852 and ShotZone != 'In The Paint (Non-RA)' and ShotZone != 'Restricted Area'
				--	THEN 'Zone4'
				WHEN (ShotZone = 'In The Paint (Non-RA)' or ShotZone = 'Restricted Area')
					THEN 'In The Paint'
			END as Zones,
			NBA.FT FreeThrows,					
			NBA.PlayerPosition,
			NBA.Opp
	FROM
		NBAShotChart Shot
		INNER JOIN NBAReferenceToShotChartMap Ref ON Ref.ShotChart_PlayerName = Shot.PlayerName
		INNER JOIN NBA_PlayerLog NBA  ON Ref.NBARef_PlayerName = NBA.PlayerName and Shot.GameDate = NBA.[Date]
	WHERE
	NBA.Opp = @team_
	) A
	Group BY 
		A.PlayerName,A.PlayerPosition, A.Shot, A.Zones, A.FreeThrows, A.GameDate, A.PlayerTeam, A.Opp
	ORDER BY
		GameDate DESC, Shot ASC, totals DESC, A.PlayerName asc
END
GO