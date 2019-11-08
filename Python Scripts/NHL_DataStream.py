import re
import os
import time
import subprocess
from datetime import datetime, timedelta
from bs4 import BeautifulSoup
import inflect 
import time
import datetime
import pyodbc

YEAR = [2019,2020] 
positionHeaders = {}
connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NHL;""Trusted_Connection=yes;")
cursor = connection.cursor()
cursor.execute("Delete from NHL_PlayerLog Where [GameDate] > '2017-10-01';")
cursor.commit()
cursor.execute("Delete from NHL_PlayerLog_Goalie Where [GameDate] > '2017-10-01';")
cursor.commit()
PlayerList = {}
cursor.execute('Select PlayerName from NHL_Player')
for each in cursor.fetchall():
    try:
        PlayerList[each.PlayerName] = 1
    finally:
        pass



playerMap = {}
def PlayerUnicodeConversion(playerName):    
    if (playerName in playerMap.keys()):
        return playerMap[playerName]
    else:
        return playerName

def ClearSpecialCharacters(data, header):
    if header:
        data = data.replace('%', 'per')

    if '\xa0' in data:        
        data = 'blank'

    if '3' in data and header:
        data = data.replace('3', 'Three')

    data = re.sub('[^a-zA-Z0-9@ \n\.\s]', '', data)
    data = data.replace(' ', '')
    return data


# Extract team urls and names
def ExtractTeams(connection, cursor):
    for year in YEAR:
        teamData = subprocess.check_output(['curl', 'https://www.hockey-reference.com/teams/'], shell = True)
        soup = BeautifulSoup(teamData[10000:], features='html.parser')
        teamDiv = soup.find('table', {'id': 'active_franchises' })
        teams =  teamDiv.findAll('a')
        for each in teams:
            if re.match('.*<a href="/teams/.*', str(each)):	
                print(each['href'])
                ExtractPlayersFromRoster(each['href'].replace("history.html", ""), each.text, year, connection, cursor)                
                
# Extract Players from team Roster
def ExtractPlayersFromRoster(teamURL, teamName, year, connection, cursor):
    if teamURL == "/teams/PHX/":
        teamURL = "/teams/ARI/"

    teamURL = 'https://www.hockey-reference.com' + teamURL + str(year) + '.html' 
    print(teamURL)    
    teamRoster = subprocess.check_output(['curl' , teamURL], shell = True)
    teamRoster = str(teamRoster)

    # Sub commented out code
    soup = BeautifulSoup( re.compile("<!--|-->").sub("",teamRoster), features='html.parser')     
    
    teamDiv = soup.find('table', {'id': 'roster'})    
    teamPlayers = teamDiv.findAll('tr')

    for i in range(1, len(teamPlayers)):
        position = ""
        player = ""
        playerLink = ""
        player = teamPlayers[i].findAll('td')
        if (len(player) > 0):
            position = player[2].text
            player = player[0]
            playerLink = player.find('a')['href']
            player = player.text
        if len(position) > 0 and len(player) > 0:
            #player = ClearSpecialCharacters(player, True)
            player = player.replace("(TW)", "")
            player = re.sub('[^a-zA-Z0-9@\n\.\s]', '', player)                
            player = PlayerUnicodeConversion(player)
            if (re.match(".*C.*",position)):
                position = "C"                                
            if (re.match(".*W.*",position)):
                position = "F"
            if (position != "G"):
                ExtractPlayersData(player, position, playerLink, year, connection, cursor)                
            else:
                ExtractPlayersDataGoalie(player, position, playerLink, year, connection, cursor)

def ExtractPlayersData(player, playerPosition, playerLink, year, connection, cursor):
    playerLink = playerLink.split('.')[0]    
    if "anderju01" in str(playerLink):        
        return
    playerLink = playerLink.replace('\'', '')
    
    playerLink = playerLink.replace('\\', '')
    playerGameLog = 'https://www.hockey-reference.com' + playerLink + '/gamelog/' + str(year) +'/'        
    print(playerGameLog)
    playerGameLog = subprocess.check_output(['curl' , playerGameLog], shell = True)
    soup = BeautifulSoup(playerGameLog[10000:], features='html.parser')
    playerGameLogData = soup.find('table', {'id': 'gamelog'}) 

    if (playerGameLogData == None):
        return 0
    WH = soup.find("span", {'itemprop' : 'weight'})

    if (WH != None):
        height, weight = str(WH.next_sibling).split(',')        
        height = re.sub('[^a-zA-Z0-9@\n\.\s]', '', height).replace('cm', '')
        weight = re.sub('[^a-zA-Z0-9@\n\.\s]', '', weight).replace('kg', '')
        try:
            if(PlayerList[player] == 1):                
                pass
        except KeyError as e:
            playerInsert = ("INSERT INTO NHL_Player VALUES (?, ?, ?, ?)")
            playerData = [player, playerPosition, int(height), int(weight)]
            cursor.execute(playerInsert, tuple(playerData))            
            cursor.commit()
            PlayerList[player] = 1
            pass        

    # Header information for the tables    
    playerGameLogDataHeader = playerGameLogData.find('thead')
    header = {}
    p = inflect.engine()

    # Header Main
    headerMain = []
    joinedHaders =  str(','.join(headerMain))
    joinedHaders = joinedHaders.replace('blank,Opp,','blank,Opp,blank2,')    
    positionHeaders[playerPosition] = joinedHaders
    count = 0

    ### DB connection and cleanup    
    playerInsertData = ("INSERT INTO NHL_PlayerLog VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ?, ?, ?, ?,? ,? ,? ,?,?,?,?,?,?,?,?,?)")
    playerDataTuple = []

    # Body of the Gamelog
    playerGameLogDataBody = playerGameLogData.find('tbody')
    for eachTD in playerGameLogDataBody.findAll('tr'):        
        playerDataTuple.append(player)
        playerDataTuple.append(playerPosition)
        playerDataTuple.append(count)

        for each in eachTD.findAll('td'):            
            playerDataTuple.append(ClearSpecialCharacters(each.text, False))        
        
        if (len(playerDataTuple) > 15 ):
            dateField = str(playerDataTuple[3])
            dateField = dateField[0:4] + "-" + dateField[4:6] + "-" + dateField[6:8]
            playerDataTuple[3] = dateField
            i = 0
            ## Convert to int fields
            for i in range(10, 23):
                if (playerDataTuple[i] != ""):
                    playerDataTuple[i] = int(playerDataTuple[i])
                else:
                    playerDataTuple[i] = 0

            for i in range(24, 30):
                if (playerDataTuple[i] != ""):
                    playerDataTuple[i] = int(playerDataTuple[i])
                else:
                    playerDataTuple[i] = 0
            
            if (playerDataTuple[23] != ""):
                playerDataTuple[23] = float(playerDataTuple[23])
            else:
                playerDataTuple[23] = 0

            if (playerDataTuple[30] != ""):
                playerDataTuple[30] = float(playerDataTuple[30])
            else:
                playerDataTuple[30] = 0

            ## Minute Second field ( 25th field)
            minField = str(playerDataTuple[25])                        
            if (len(minField) == 4 ):
                minField = int(minField[0:2])*60 + int(minField[2:4])
            else:
                if (len(minField) == 3 ):
                    minField = int(minField[0])*60 + int(minField[0:2])                     
            playerDataTuple[25] = minField
            cursor.execute(playerInsertData, tuple(playerDataTuple))
            cursor.commit()            
            playerDataTuple = []    
            count += 1
        else:
            playerDataTuple = []
            count += 1

    return 0

def ExtractPlayersDataGoalie(player, playerPosition, playerLink, year, connection, cursor):
    playerLink = playerLink.split('.')[0]    
    if "anderju01" in str(playerLink):        
        return
    playerLink = playerLink.replace('\'', '')
    
    playerLink = playerLink.replace('\\', '')
    playerGameLog = 'https://www.hockey-reference.com' + playerLink + '/gamelog/' + str(year) +'/'        
    print(playerGameLog)
    playerGameLog = subprocess.check_output(['curl' , playerGameLog], shell = True)
    soup = BeautifulSoup(playerGameLog[10000:], features='html.parser')
    playerGameLogData = soup.find('table', {'id': 'gamelog'}) 

    if (playerGameLogData == None):
        return 0
    WH = soup.find("span", {'itemprop' : 'weight'})

    if (WH != None):
        height, weight = str(WH.next_sibling).split(',')        
        height = re.sub('[^a-zA-Z0-9@\n\.\s]', '', height).replace('cm', '')
        weight = re.sub('[^a-zA-Z0-9@\n\.\s]', '', weight).replace('kg', '')
        try:
            if(PlayerList[player] == 1):                
                pass
        except KeyError as e:
            playerInsert = ("INSERT INTO NHL_Player VALUES (?, ?, ?, ?)")
            playerData = [player, playerPosition, int(height), int(weight)]
            cursor.execute(playerInsert, tuple(playerData))            
            cursor.commit()
            PlayerList[player] = 1
            pass        

    # Header information for the tables    
    playerGameLogDataHeader = playerGameLogData.find('thead')
    header = {}
    p = inflect.engine()

    # Header Main
    headerMain = []
    joinedHaders =  str(','.join(headerMain))
    joinedHaders = joinedHaders.replace('blank,Opp,','blank,Opp,blank2,')    
    positionHeaders[playerPosition] = joinedHaders
    count = 0

    ### DB connection and cleanup    
    playerInsertData = ("INSERT INTO NHL_PlayerLog_Goalie VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
    playerDataTuple = []

    # Body of the Gamelog
    playerGameLogDataBody = playerGameLogData.find('tbody')
    for eachTD in playerGameLogDataBody.findAll('tr'):        
        playerDataTuple.append(player)
        playerDataTuple.append(playerPosition)
        playerDataTuple.append(count)

        for each in eachTD.findAll('td'):            
            playerDataTuple.append(ClearSpecialCharacters(each.text, False))        
        
        if (len(playerDataTuple) > 15 ):
            dateField = str(playerDataTuple[3])
            dateField = dateField[0:4] + "-" + dateField[4:6] + "-" + dateField[6:8]
            playerDataTuple[3] = dateField
            i = 0
            
            ## Convert to int fields
            for i in range(11, 14):
                if (playerDataTuple[i] != ""):
                    playerDataTuple[i] = int(playerDataTuple[i])
                else:
                    playerDataTuple[i] = 0            

            ## Convert to int fields
            for i in range(15, 17):
                if (playerDataTuple[i] != ""):
                    playerDataTuple[i] = int(playerDataTuple[i])
                else:
                    playerDataTuple[i] = 0            


            if (playerDataTuple[14] != ""):
                playerDataTuple[14] = float(playerDataTuple[14])
            else:
                playerDataTuple[14] = 0




            ## Minute Second field ( 25th field)
            minField = str(playerDataTuple[17])                        
            if (len(minField) == 4 ):
                minField = int(minField[0:2])*60 + int(minField[2:4])
            else:
                if (len(minField) == 3 ):
                    minField = int(minField[0])*60 + int(minField[0:2])                     
            playerDataTuple[17] = minField
            cursor.execute(playerInsertData, tuple(playerDataTuple))
            cursor.commit()
            playerDataTuple = []    
            count += 1
        else:
            playerDataTuple = []
            count += 1

    return 0

ExtractTeams(connection, cursor)