
-- EXEC usp_GetPlayersForDate @date_ = '2019-1-24', @teamName_ = 'NOP', @oppName_ = 'TOR'
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
			Team,
			FL_DateTime GameDate
		FROM
			NBA_Player N (NOLOCK)
			INNER JOIN NBAReferenceToDraftKings DK ON DK.DK_PlayerName = N.PlayerName
			INNER JOIN NBA_FantasyLabs FL ON FL.Player_Name = DK.DK_PlayerName AND FL_DateTime =  @date_
			INNER JOIN NBA_PlayerLog P ON P.PlayerName = N.PlayerName
		WHERE 
			FL.FL_DateTime = @date_
			AND (Team = @teamName_ or Team = @oppName_)
	ORDER BY Team ASC
END
