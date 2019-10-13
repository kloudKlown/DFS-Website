
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
		Tm HomeTeam,		
		Opp AwayTeam
	FROM
		NBA_PlayerLog
	WHERE
		[Date] = @date_
		and blank <> '@'
END


