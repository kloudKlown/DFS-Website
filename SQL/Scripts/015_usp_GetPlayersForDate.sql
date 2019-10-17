
-- EXEC usp_GetPlayersForDate @date_ = '2018-12-12', @teamName_ = 'PHI', @oppName_ = 'BRK'
DROP PROCEDURE IF EXISTS usp_GetPlayersForDate
GO

CREATE PROCEDURE usp_GetPlayersForDate
(
	@date_ DateTime,
	@teamName_ nvarchar(3),
	@oppName_ nvarchar(3)
)
AS
BEGIN
	SELECT
			DISTINCT
			N.PlayerName [Name],
			CASE
				WHEN FL.Salary IS NULL
					THEN P.PlayerPosition			
				WHEN FL.Salary IS NOT NULL
					THEN FL.Salary
			END Position,
			Height,
			[Weight],
			P.Tm Team,
			P.[date] GameDate
		FROM
			NBA_Player N (NOLOCK)
			INNER JOIN NBA_PlayerLog P ON P.PlayerName = N.PlayerName
			LEFT JOIN NBAReferenceToDraftKings DK ON DK.DK_PlayerName = P.PlayerName
			LEFT JOIN NBA_FantasyLabs FL ON FL.Player_Name = DK.DK_PlayerName AND FL_DateTime =  @date_
		WHERE 
			P.[Date] = @date_
			AND (Tm = @teamName_ or Tm = @oppName_)
	ORDER BY Tm ASC
END
