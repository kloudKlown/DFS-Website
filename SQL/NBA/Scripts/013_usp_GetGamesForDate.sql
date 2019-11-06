
-- EXEC usp_GetGamesForDate @date_ = '2018-11-10'
DROP PROCEDURE IF EXISTS usp_GetGamesForDate
GO

CREATE PROCEDURE usp_GetGamesForDate
(
	@date_ DateTime
)
AS

BEGIN
	Select
		DISTINCT
		Team HomeTeam,
		Opp AwayTeam,
		OU OverUnder,
		Line,
		FV Favourite
	FROM
		NBA_Games
	WHERE
		GameDate = @date_		
END


