DELETE FROM NBAReferenceToShotChartMap;

Select 
	Distinct Shot.PlayerName Shots, NBARef.PlayerName Ref From NBAShotChart Shot
INNER JOIN
	NBA_PlayerLog NBARef 
ON
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NBARef.PlayerName, '-', ''), '''',''), '.', ''),'Jr',''), 'III',''),'IV', '') =
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Shot.PlayerName, '-', ''), '''',''), '.', ''), 'Jr',''), 'III',''),'IV', '')
WHERE 
	NBARef.PlayerName is NULL;

-- SELECT DISTINCT PlayerName FROM NBA_PlayerLog where PlayerName like '%Reddish%'

INSERT INTO NBAReferenceToShotChartMap
SELECT
	Distinct Shot.PlayerName, 
	NBARef.PlayerName 
From 
	NBAShotChart Shot INNER JOIN NBA_PlayerLog NBARef  ON 
REPLACE(REPLACE(REPLACE(REPLACE(NBARef.PlayerName, '-', ''), '''',''), '.', ''),'Jr','') = 
REPLACE(REPLACE(REPLACE(REPLACE(Shot.PlayerName, '-', ''), '''',''), '.', ''), 'Jr','')

INSERT INTO NBAReferenceToShotChartMap values
('Luka Doncic','Luka Donic'),
('Taurean Prince', 'Taurean WallerPrince'),
('Nene','Nene Hilario'),
('Wes Iwundu', 'Wesley Iwundu'),
('Svi Mykhailiuk', 'Sviatoslav Mykhailiuk'),
('Jakob Poeltl', 'Jakob Poltl'),
('Gary Payton II', 'Gary Payton'),
('Juancho Hernangomez', 'Juan Hernangomez'),
('Vince Edwards', 'Vincent Edwards');
