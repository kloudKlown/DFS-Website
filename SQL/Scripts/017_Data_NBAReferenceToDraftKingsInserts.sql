Delete From [NBAReferenceToDraftKings]
GO

INSERT INTO [NBAReferenceToDraftKings]
		SELECT DISTINCT PL.PlayerName NBARef, FL.[Player_Name] FantasyLabs
		FROM NBA_PlayerLog PL
		INNER JOIN NBA_FantasyLabs FL ON FL.Player_Name = PL.PlayerName		

INSERT INTO NBAReferenceToDraftKings VALUES ('Jakob Poltl', 'Jakob Poeltl');
INSERT INTO NBAReferenceToDraftKings VALUES ('Luka Donic', 'Luka Doncic');
INSERT INTO NBAReferenceToDraftKings VALUES ('Isaac Humphries', 'Issac Humphries');
INSERT INTO NBAReferenceToDraftKings VALUES ('Vince Edwards', 'Vincent Edwards');
INSERT INTO NBAReferenceToDraftKings VALUES ('T.J. McConnell', 'TJ McConnell');
INSERT INTO NBAReferenceToDraftKings VALUES ('Shai GilgeousAlexander', 'S. GilgeousAlexander');
INSERT INTO NBAReferenceToDraftKings VALUES ('Brad Wanamaker', 'Bradley Wanamaker');
INSERT INTO NBAReferenceToDraftKings VALUES ('J.J. Redick', 'JJ Redick');
INSERT INTO NBAReferenceToDraftKings VALUES ('P.J. Tucker', 'PJ Tucker');
INSERT INTO NBAReferenceToDraftKings VALUES ('R.J. Hunter', 'RJ Hunter');
INSERT INTO NBAReferenceToDraftKings VALUES ('T.J. Warren', 'TJ Warren');
INSERT INTO NBAReferenceToDraftKings VALUES ('C.J. Miles', 'CJ Miles');
INSERT INTO NBAReferenceToDraftKings VALUES ('T.J. Leaf', 'TJ Leaf');
INSERT INTO NBAReferenceToDraftKings VALUES ('Wesley Iwundu', 'Wes Iwundu');
INSERT INTO NBAReferenceToDraftKings VALUES ('Derrick Jones', 'Derrick Jones Jr.');
INSERT INTO NBAReferenceToDraftKings VALUES ('Tim Hardaway', 'Tim Hardaway Jr.');
INSERT INTO NBAReferenceToDraftKings VALUES ('Dennis Smith', 'Dennis Smith Jr.');
INSERT INTO NBAReferenceToDraftKings VALUES ('Rondae HollisJefferson', 'R. HollisJefferson');
INSERT INTO NBAReferenceToDraftKings VALUES ('Larry Nance', 'Larry Nance Jr.');
INSERT INTO NBAReferenceToDraftKings VALUES ('Shaquille Harrison', 'Shaq Harrison');
INSERT INTO NBAReferenceToDraftKings VALUES ('Kostas Antetokounmpo', 'K. Antetokounmpo');
INSERT INTO NBAReferenceToDraftKings VALUES ('Taurean WallerPrince', 'Taurean Prince');
INSERT INTO NBAReferenceToDraftKings VALUES ('Michael CarterWilliams', 'M. CarterWilliams');
INSERT INTO NBAReferenceToDraftKings VALUES ('Willie CauleyStein', 'W. CauleyStein');
INSERT INTO NBAReferenceToDraftKings VALUES ('Isaiah Hartenstein', 'I. Hartenstein');
INSERT INTO NBAReferenceToDraftKings VALUES ('Dorian FinneySmith', 'D. FinneySmith');
INSERT INTO NBAReferenceToDraftKings VALUES ('Giannis Antetokounmpo', 'G. Antetokounmpo');
INSERT INTO NBAReferenceToDraftKings VALUES ('Michael KiddGilchrist', 'M. KiddGilchrist');
INSERT INTO NBAReferenceToDraftKings VALUES ('Dairis Bertxc4x81ns', 'Dairis Bertans');
INSERT INTO NBAReferenceToDraftKings VALUES ('Matthew Dellavedova', 'M. Dellavedova');
INSERT INTO NBAReferenceToDraftKings VALUES ('Timothe LuwawuCabarrot', 'Timothe Luwawu');
INSERT INTO NBAReferenceToDraftKings VALUES ('Malachi Richardson', 'M. Richardson');
INSERT INTO NBAReferenceToDraftKings VALUES ('Walt Lemon', 'Walter Lemon Jr.');
INSERT INTO NBAReferenceToDraftKings VALUES ('James Young', 'Trae Young');
INSERT INTO NBAReferenceToDraftKings VALUES ('Tyler Davis', 'Tyler Ulis');
INSERT INTO NBAReferenceToDraftKings VALUES ('Mo Bamba', 'Mohamed Bamba');
INSERT INTO NBAReferenceToDraftKings VALUES ('Kentavious CaldwellPope', 'K. CaldwellPope');
INSERT INTO NBAReferenceToDraftKings VALUES ('Chandler Hutchison', 'C. Hutchison');
INSERT INTO NBAReferenceToDraftKings VALUES ('Sindarius Thornwell', 'S. Thornwell');
INSERT INTO NBAReferenceToDraftKings VALUES ('Sviatoslav Mykhailiuk', 'S. Mykhailiuk');
INSERT INTO NBAReferenceToDraftKings VALUES ('Guerschon Yabusele', 'G. Yabusele');
INSERT INTO NBAReferenceToDraftKings VALUES ('J.J. Barea', 'Jose Juan Barea');
INSERT INTO NBAReferenceToDraftKings VALUES ('RJ Barrett', 'R.J. Barrett');
INSERT INTO NBAReferenceToDraftKings VALUES ('Glenn Robinson III', 'Glenn Robinson');
INSERT INTO NBAReferenceToDraftKings VALUES ('Wendell Carter Jr.', 'Wendell Carter');
INSERT INTO NBAReferenceToDraftKings VALUES ('Jaren Jackson Jr.', 'Jaren Jackson');
INSERT INTO NBAReferenceToDraftKings VALUES ('Marvin Bagley III', 'Marvin Bagley');
INSERT INTO NBAReferenceToDraftKings VALUES ('Donte Grantham', 'Devonte Graham');
INSERT INTO NBAReferenceToDraftKings VALUES ('Kelly Oubre Jr.', 'Kelly Oubre');
INSERT INTO NBAReferenceToDraftKings VALUES ('Gary Trent Jr.', 'Gary Trent');
INSERT INTO NBAReferenceToDraftKings VALUES ('Troy Brown Jr.', 'Troy Brown');
INSERT INTO NBAReferenceToDraftKings VALUES ('Nickeil AlexanderWalker', 'N. AlexanderWalker');
INSERT INTO NBAReferenceToDraftKings VALUES ('Nicolxc3xb2 Melli', 'Nicolo Melli');
INSERT INTO NBAReferenceToDraftKings VALUES ('Zion Williamson', 'Zion Williamson');
INSERT INTO NBAReferenceToDraftKings VALUES ('Kristaps Porzingis', 'K. Porzingis');
