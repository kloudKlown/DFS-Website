DELETE FROM NBAReferenceToShotChartMap;

Select 
	Distinct Shot.PlayerName Shots, NBARef.PlayerName Ref From NBAShotChart Shot
INNER JOIN
	NBA_PlayerLog NBARef 
ON
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NBARef.PlayerName, '-', ''), '''',''), '.', ''), 'Jr',''), 'III',''),'IV', ''), ' ', ''),'III','')=
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Shot.PlayerName, '-', ''), '''',''), '.', ''), 'Jr',''), 'III',''),'IV', ''), ' ', ''),'III','')
WHERE 
	NBARef.PlayerName is NULL;

-- SELECT DISTINCT PlayerName FROM NBA_PlayerLog where PlayerName like '%Reddish%'

INSERT INTO NBAReferenceToShotChartMap
SELECT
	Distinct 
	Shot.PlayerName, 
	NBARef.PlayerName 
From 
	NBAShotChart Shot INNER JOIN NBA_PlayerLog NBARef  ON 
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NBARef.PlayerName, '-', ''), '''',''), '.', ''),'Jr',''), 'III',''),'IV', ''), ' ', ''),'II',''),'  ','') = 
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Shot.PlayerName, '-', ''), '''',''), '.', ''), 'Jr',''), 'III',''),'IV', ''), ' ', ''),'III',''),'  ','')


INSERT INTO NBAReferenceToShotChartMap values
('Luka Doncic','Luka Donic'),
('Taurean Prince', 'Taurean WallerPrince'),
('Nene','Nene Hilario'),
('Wes Iwundu', 'Wesley Iwundu'),
('Svi Mykhailiuk', 'Sviatoslav Mykhailiuk'),
('Jakob Poeltl', 'Jakob Poltl'),
('Gary Payton II', 'Gary Payton'),
('Juancho Hernangomez', 'Juan Hernangomez'),
('Vince Edwards', 'Vincent Edwards'),
('Joel Embiid', 'Joel Embiid'),
('Vincent Edwards', 'Vinc Edwards'),
('Walter Lemon Jr.','Walt Lemon');



Select DISTINCT 
	SH.PlayerName, DK.ShotChart_PlayerName FROM NBAShotChart SH
	LEFT JOIN NBAReferenceToShotChartMap DK ON SH.PlayerName = DK.ShotChart_PlayerName
WHERE
	DK.ShotChart_PlayerName IS NULL


--Select * FROM NBAShotChart where PlayerName like '%Walter Lemon%'
--Select * FROM NBA_Player where PlayerName like '%Bertans%'
