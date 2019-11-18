
-- EXEC usp_GetPlayersForDate @date_ = '2019-10-25', @teamName_ = 'CHI', @oppName_ = 'TOR'
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
				WHEN FL.Pos IS NULL
					THEN P.PlayerPosition			
				WHEN FL.Pos IS NOT NULL
					THEN FL.Pos
			END Position,
			Height,
			[Weight],
			FL.Team,
			FL_DateTime GameDate,
			CAST(ISNULL(DKP.RFPred, 0) AS NUMERIC(8,2)) Predicted,
			FL.Salary ActualSalary,
			CAST((ISNULL(DKP.Salary, 0) - REPLACE(ISNULL(FL.Salary,0), '$', '')) as int) SalaryDiff,
			CAST((ISNULL(DKP.Actual, 0)) AS NUMERIC(8,2))  Actual
		FROM
			NBA_Player N (NOLOCK)
			INNER JOIN NBAReferenceToDraftKings DK ON DK.NBARef_PlayerName = N.PlayerName
			INNER JOIN NBA_FantasyLabs FL ON FL.Player_Name = DK.DK_PlayerName AND FL_DateTime =  @date_
			INNER JOIN NBA_PlayerLog P ON P.PlayerName = N.PlayerName
			LEFT JOIN NBA_DK_Prediction DKP ON DKP.player = N.PlayerName AND DKP.[date] = @date_
		WHERE 
			FL.FL_DateTime = @date_
			AND (FL.Team = @teamName_ or FL.Team = @oppName_)
	ORDER BY FL.Team ASC
END
