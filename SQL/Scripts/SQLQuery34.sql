--Select DISTINCT top 100 ShotDistanceDesc From NBAShotChart -- where ShotDistanceDesc <> 'Less Than 8 ft.'
Select DISTINCT top 10 ShotZone, ShotPosition From NBAShotChart -- where ShotDistanceDesc <> 'Less Than 8 ft.'


	SELECT 
	TOP 300
	A.GameDate, A.PlayerName, A.PlayerTeam Team,  A.Opp Opp, A.PlayerPosition Position, CAST(count(A.Shot) as int) Totals, 
	CAST(A.FreeThrows as int) FreeThrows, A.Zones, A.Shot
	FROM
	(
	Select 
			Shot.*,
			CASE
				WHEN ShotZone = 'Left Corner 3' and ShotPosition = 'Left Side(L)'
					THEN 'Left Corner 3'
				WHEN ShotZone = 'Above The Break 3' and ShotPosition = 'Right Side Center(RC)'
					THEN 'Right 3'
				WHEN ShotZone = 'Right Corner 3' and ShotPosition = 'Right Side(R)'
					THEN 'Right Corner 3'

				WHEN ShotZone = 'Above The Break 3' and ShotPosition = 'Left Side Center(LC)'
					THEN 'Left 3'
				WHEN ShotZone = 'Above The Break 3' and ShotPosition = 'Center(C)'
					THEN 'Center 3'
				WHEN ShotZone = 'Mid-Range' and ShotPosition = 'Left Side Center(LC)'
					THEN 'Left 2'
				WHEN ShotZone = 'Mid-Range' and ShotPosition = 'Right Side Center(RC)'
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
		INNER JOIN NBAReferenceToShotChartMap Ref ON Ref.NBARef_PlayerName = Shot.PlayerName
		INNER JOIN NBA_PlayerLog NBA  ON Ref.ShotChart_PlayerName = NBA.PlayerName and Shot.GameDate = NBA.Date
	WHERE
	NBA.PlayerName in ('Lebron James', 'Anthony Davis', 'Danny Green')
	) A
	Group BY 
		A.PlayerName,A.PlayerPosition, A.Shot, A.Zones, A.FreeThrows, A.GameDate, A.PlayerTeam, A.Opp
	ORDER BY
		GameDate DESC, Shot ASC, totals DESC, A.PlayerName asc
