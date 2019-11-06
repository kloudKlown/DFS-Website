-- EXEC usp_GetAllPlayers

DROP PROCEDURE IF EXISTS usp_GetAllPlayers
GO

CREATE PROCEDURE usp_GetAllPlayers
AS
BEGIN

	SELECT
		PlayerName [Name],
		Position,
		Height,
		[Weight]
	FROM
		NBA_Player (NOLOCK)
END
GO