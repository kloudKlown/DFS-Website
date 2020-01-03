DROP PROCEDURE IF EXISTS usp_GetPlayerLogs
GO

CREATE PROCEDURE usp_GetPlayerLogs
AS
BEGIN

Select 
	PL.*, 
	CASE
		WHEN CAST(REPLACE(DKF.Line, '--', '0') as int) > 0
			THEN
				DKF.Line
			ELSE	
				0
	END Line, 
	DKF.VegasT 
From
	[NHL_PlayerLog] PL INNER JOIN NHL.[dbo].[NHLReferenceToDraftKings] DK 
ON
	PL.PlayerName = DK.NHLRef_PlayerName
	INNER JOIN NHL.dbo.[NHL_FantasyLabs] DKF
ON 
	DKF.Player_Name = PL.PlayerName and PL.GameDate = DKF.FL_Datetime
Where 
	GameDate > '2017-10-01'

END