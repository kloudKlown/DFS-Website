
-- EXEC usp_GetNCAAPrediction @date_ = '2020-01-04'
DROP PROCEDURE IF EXISTS usp_GetNCAAPrediction
GO

CREATE PROCEDURE usp_GetNCAAPrediction
(
	@date_ DATETIME NULL
)
AS
BEGIN

	Select 
		NCAA.player Player, NCAA.position Position, CAST(ISNULL(P.Height, 0) as INT) Height, 
		CAST(ISNULL(P.Weight, 0) AS INT) Weight, NCAA.Team, NCAA.Opp,
		NCAA.RFPred, NCAA.MP, NCAA.assists, DK2.TOTAL Total, DK2.TotalTeamScore, 
		DK2.AveragePointsAllowed, DK2.AveragePointsScored, 
		CAST(V.Line as int) Line, CAST(V.FV as nvarchar) FV, CAST(V.OU as INT) OU, DK2.OpposingTeamScore
	FROM 
		[dbo].NCAA_DK_Prediction NCAA 
	INNER JOIN NCAA_DK_Prediction2 DK2 ON DK2.Team = NCAA.Team
	LEFT JOIN NCAA_Player P ON P.PlayerName = REPLACE(NCAA.player, ' ', '')
	INNER JOIN NCAA_Vegas_Teams_Mapping M ON (LOWER(M.NCAA_Team) = NCAA.Team OR LOWER(M.NCAA_Team) = NCAA.Opp)
	INNER JOIN NCAA_Games V On (M.Vegas_Team like V.Team)
	AND 
		V.GameDate = CAST(@date_ as date) 
	AND 
		V.Line IS NOT NULL

END
