DROP PROCEDURE IF EXISTS usp_UpdateSelectedPlayers
GO

CREATE PROCEDURE usp_UpdateSelectedPlayers
(
	@date_ DATETIME,
	@name_ NVARCHAR(100),
	@team_ NVARCHAR(3)
)
AS
BEGIN
	DECLARE @ID INT = NULL;

	SELECT
		@ID = ID
	FROM
		NBA_SelectedPlayers SP
	WHERE
		SP.GameDate = @date_
		AND SP.Team = @team_
		AND SP.Name = @name_

	IF (NOT @ID IS NULL)
		DELETE FROM NBA_SelectedPlayers
		WHERE
			GameDate = @date_
			AND Team = @team_
			AND [Name] = @name_
	ELSE
		INSERT INTO NBA_SelectedPlayers VALUES (@date_, @team_, @name_)

	SELECT 1
END
GO



