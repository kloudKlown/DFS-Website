DELETE FROM NBAReferenceToShotChartMap;

--Select 
--	Distinct Shot.PlayerName, NBARef.PlayerName From NBAShotChart Shot
--LEFT JOIN
--	NBATableData NBARef 
--ON
--	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(NBARef.PlayerName, '-', ''), '''',''), '.', ''),'Jr',''), 'III',''),'IV', '') =
--	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Shot.PlayerName, '-', ''), '''',''), '.', ''), 'Jr',''), 'III',''),'IV', '')
--WHERE 
--	NBARef.PlayerName is NULL;

--SELECT DISTINCT PlayerName FROM NBATableData where PlayerName like '%Edwards%'

INSERT INTO NBAReferenceToShotChartMap
SELECT
	Distinct Shot.PlayerName, 
	NBARef.PlayerName 
From 
	NBAShotChart Shot INNER JOIN NBATableData NBARef  ON 
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
('Dairis Bertans','Davis Bertans'),
('Vince Edwards', 'Vincent Edwards')
