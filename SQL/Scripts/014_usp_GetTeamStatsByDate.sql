 EXEC usp_GetTeamStatsByDate @date_ = '2018-12-10', @teamName_ = 'NOP', @oppName_ = 'BOS'
DROP PROCEDURE IF EXISTS usp_GetTeamStatsByDate
GO

CREATE PROCEDURE usp_GetTeamStatsByDate
(
	@date_ DateTime,
	@teamName_ nvarchar(3),
	@oppName_ nvarchar(3)
)
AS
BEGIN
	Select
		PL.PlayerName, 
		PL.Tm Team,		
		PL.PlayerPosition,
		AVG(P.Height) Height,
		AVG(P.[Weight]) [Weight],
		TIMEFROMPARTS(0, ROUND(AVG(PL.MP/60), 0, 0), (AVG(CAST(PL.MP as INT)) - ROUND(AVG(CAST(PL.MP as INT))/60, 0, 0)*60), 0, 0) MinutesPlayed,
		AVG(PLA.USGPer) 'Usage',		
		AVG(PLA.DRTGPer) 'Def Rating',	
		AVG(PLA.ORTGPer) 'Off Rating',	
		AVG(FG) 'Field Goals',
		AVG(FGA) 'Field Goals Attempted',
		AVG(Threep) '3 Pointers',
		AVG(ThreepA) '3 Pointers Attempted',
		AVG(AST) 'Assists',
		AVG(DRB) 'Def Rebounds',
		AVG(ORB) 'Off Rebounds',
		AVG(TRB) 'Total Rebounds',
		AVG(PLA.TRBPer) 'Total Rebounds Per',
		AVG(FT) 'Free Throws',		
		AVG(BLK) 'Blocks',
		AVG(STL) 'Steals',
		AVG(PTS) 'Points'
	FROM
		NBA_PlayerLog PL INNER JOIN NBA_Player P ON P.PlayerName = PL.PlayerName	
		INNER JOIN NBA_PlayerLog_Advanced PLA ON PLA.PlayerName = PL.PlayerName AND PLA.[Date] = PL.[Date]
	WHERE PL.[Date] in (SELECT TOP 5 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @teamName_ ORDER BY [DATE] desc )					
	and PL.Tm = @teamName_
	GROUP BY PL.PlayerName, PL.Tm, PL.PlayerPosition
	ORDER BY MinutesPlayed DESC

	Select
		PL.PlayerName, 
		PL.Tm Team,		
		PL.PlayerPosition Position,
		AVG(P.Height) Height,
		AVG(P.[Weight]) [Weight],
		TIMEFROMPARTS(0, ROUND(AVG(PL.MP/60), 0, 0), (AVG(CAST(PL.MP as INT)) - ROUND(AVG(CAST(PL.MP as INT))/60, 0, 0)*60), 0, 0) MinutesPlayed,
		AVG(PLA.USGPer) 'Usage',		
		AVG(PLA.DRTGPer) 'Def Rating',	
		AVG(PLA.ORTGPer) 'Off Rating',	
		AVG(FG) 'Field Goals',
		AVG(FGA) 'Field Goals Attempted',
		AVG(Threep) '3 Pointers',
		AVG(ThreepA) '3 Pointers Attempted',
		AVG(AST) 'Assists',
		AVG(DRB) 'Def Rebounds',
		AVG(ORB) 'Off Rebounds',
		AVG(TRB) 'Total Rebounds',
		AVG(PLA.TRBPer) 'Total Rebounds Per',
		AVG(FT) 'Free Throws',		
		AVG(BLK) 'Blocks',
		AVG(STL) 'Steals',
		AVG(PTS) 'Points'
	FROM
		NBA_PlayerLog PL INNER JOIN NBA_Player P ON P.PlayerName = PL.PlayerName	
		INNER JOIN NBA_PlayerLog_Advanced PLA ON PLA.PlayerName = PL.PlayerName AND PLA.[Date] = PL.[Date]
	WHERE PL.[Date] in (SELECT TOP 5 [Date] FROM NBA_PlayerLog where [Date] < @date_ AND Tm = @oppName_ ORDER BY [DATE] desc )					
	and PL.Tm = @oppName_
	GROUP BY PL.PlayerName, PL.Tm, PL.PlayerPosition
	ORDER BY MinutesPlayed DESC

END