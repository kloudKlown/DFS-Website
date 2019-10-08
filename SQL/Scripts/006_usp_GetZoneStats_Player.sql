-- EXEC usp_GetZoneStats_Player @Team = 'GSW'

DROP PROCEDURE IF EXISTS usp_GetZoneStats_Player
GO

CREATE PROCEDURE usp_GetZoneStats_Player
(
	@Team NVARCHAR(5) NULL
)
AS
BEGIN

	SELECT 
	A.GameDate, A.PlayerName, @Team Team,  A.Opp Opp, A.PlayerPosition Position, count(A.Shot) Totals, 
	A.FreeThrows, A.Zones, A.Shot
	FROM
	(
	Select 
			Shot.*,
			CASE
				WHEN ShotDistanceX > -248 and ShotDistanceX <= 0 and ShotDistanceY > -248 and ShotDistanceY < 130 and ShotZone != 'In The Paint (Non-RA)' and ShotZone != 'Restricted Area'
					THEN 'Zone1'
				WHEN ShotDistanceX > 0 and ShotDistanceX < 250 and ShotDistanceY > -248 and ShotDistanceY < 130 and ShotZone != 'In The Paint (Non-RA)' and ShotZone != 'Restricted Area'
					THEN 'Zone2'
				WHEN ShotDistanceX > -248 and ShotDistanceX <= 0 and ShotDistanceY > 130 and ShotDistanceY < 852 and ShotZone != 'In The Paint (Non-RA)' and ShotZone != 'Restricted Area'
					THEN 'Zone3'
				WHEN ShotDistanceX > 0 and ShotDistanceX < 250 and ShotDistanceY > 130 and ShotDistanceY < 852 and ShotZone != 'In The Paint (Non-RA)' and ShotZone != 'Restricted Area'
					THEN 'Zone4'
				WHEN (ShotZone = 'In The Paint (Non-RA)' or ShotZone = 'Restricted Area')
					THEN 'In The Paint'
			END as Zones,
			NBA.FT FreeThrows,					
			NBA.PlayerPosition,
			NBA.Opp
	FROM
		NBAShotChart Shot
		INNER JOIN NBAReferenceToShotChartMap Ref ON Ref.NBARef_PlayerName = Shot.PlayerName
		INNER JOIN NBATableData NBA  ON Ref.ShotChart_PlayerName = NBA.PlayerName and Shot.GameDate = NBA.Date
	WHERE
	PlayerTeam = @Team
	) A
	Group BY 
		A.PlayerName,A.PlayerPosition, A.Shot, A.Zones, A.FreeThrows, A.GameDate, A.Opp
	ORDER BY
		GameDate ASC, Shot ASC, totals DESC, A.PlayerName asc
END
GO