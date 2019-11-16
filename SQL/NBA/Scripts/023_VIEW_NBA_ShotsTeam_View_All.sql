DROP VIEW IF EXISTS [dbo].[NBA_ShotsTeam_View_All]
GO

CREATE VIEW
	NBA_ShotsTeam_View_All
AS

	SELECT
		PVT.GameDate, PVT.HomeTeam, ISNULL([Right 3], 0) 'R3', 
		ISNULL([Left 3],0) 'L3', ISNULL([Center 3], 0) 'C3', ISNULL([In the Paint], 0) 'IP', ISNULL([Right Corner 3], 0) 'RC3',
		ISNULL([Left Corner 3],0) 'LC3', ISNULL([Back 3],0) 'B3', ISNULL([Left 2],0) 'L2', ISNULL([Right 2], 0) 'R2', 
		ISNULL([Center 2],0) 'C2', PVT.[Made Shot], PVT.[Missed Shot]
	FROM
	 (
		SELECT 
			PV.GameDate, PV.HomeTeam, PV.Shot, [Right 3], [Left 3], [Center 3], [In the Paint], [Right Corner 3], [Left Corner 3], [Back 3], [Left 2], [Right 2], [Center 2]
		FROM

			(		
			SELECT 
				A.GameDate, A.HomeTeam, CAST(count(A.Shot) as int) Totals, A.Zones, A.Shot
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
			--WHERE
			--NBA.PlayerName = 'Bradley Beal'
			) A
			Group BY 
				A.GameDate, A.HomeTeam, A.Shot, A.Zones
			) V
			PIVOT(
				SUM(V.Totals)
				FOR V.Zones in ([Right 3], [Left 3], [Center 3], [In the Paint], 
						[Right Corner 3], [Left Corner 3], [Back 3],
						[Left 2], [Right 2], [Center 2])
				)
				PV
		--	ORDER BY PV.GameDate asc
	 )
	 K
	 PIVOT
		(
			Count(K.Shot)
			FOR K.Shot in ([Missed Shot], [Made Shot])
		)
	PVT
--	ORDER BY PVT.GameDate ASC, PVT.HomeTeam ASC
GO