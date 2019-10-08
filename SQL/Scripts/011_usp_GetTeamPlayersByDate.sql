/*
 Get Team players for given date or all dates if no date specified
*/

-- exec usp_GetTeamPlayersByDate @gameDate_ = '2018-10-18'
DROP PROCEDURE IF EXISTS usp_GetTeamPlayersByDate
GO

CREATE PROCEDURE usp_GetTeamPlayersByDate
(
	@gameDate_ datetime = NULL
)
AS
BEGIN
	SELECT
		N.PlayerName [Name],
		Position,
		Height,
		[Weight],
		P.Tm Team,
		P.[date] GameDate

	FROM
		NBA_Player N (NOLOCK)
		INNER JOIN NBA_PlayerLog P ON P.PlayerName = N.PlayerName
	WHERE
		P.[date] = @gameDate_ or @gameDate_ is NULL
	ORDER BY GameDate asc, Name asc
END

