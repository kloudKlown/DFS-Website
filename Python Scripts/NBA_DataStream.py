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

YEAR = [2018,2019] 
positionHeaders = {}
connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NBA;""Trusted_Connection=yes;")
cursor = connection.cursor()
cursor.execute("Delete from NBA_PlayerLog Where [Date] > '2019-10-21';")
cursor.commit()
cursor.execute("Delete from NBA_PlayerLog_Advanced Where [Date] > '2019-10-21';")
cursor.commit()

PlayerList = {}
cursor.execute('Select PlayerName from NBA_Player')
for each in cursor.fetchall():
    try:
        PlayerList[each.PlayerName] = 1
    finally:
        pass



playerMap = {}
def PlayerUnicodeConversion(playerName):    
    playerMap["Dennis Schrxc3xb6der"] = "Dennis Schroder"
    playerMap["Ersan xc4xb0lyasova"] = "Ersan Ilyasova"
    playerMap["Nicolxc3xa1s Brussino"] = "Nicolas Brussino"
    playerMap["Cristiano Felxc3xadcio"] = "Cristiano Felicio"
    playerMap["Josxc3xa9 Calderxc3xb3n"] = "Jose Calderon"
    playerMap["Juan Hernangxc3xb3mez"] = "Juan Hernangomez"
    playerMap["Nikola Jokixc4x87"] = "Nikola Jokic"
    playerMap["Nikola Mirotixc4x87"] = "Nikola Mirotic"
    playerMap["Willy Hernangxf3mez"] = "Willy Hernangomez"
    playerMap["Willy Hernangxc3xb3mez"] = "Willy Hernangomez"    
    playerMap["Nenxea Hilxe1rio"] = "Nene Hilario"
    playerMap["Ante xc5xbdixc5xbeixc4x87"] = "Ante Zizic"
    playerMap["Boban Marjanovixc4x87"] = "Boban Marjanovic"
    playerMap["Bojan Bogdanovixc4x87"] = "Bojan Bogdanovic"
    playerMap["Bogdan Bogdanovixc4x87"] = "Bogdan Bogdanovic"
    playerMap["xc3x96mer Axc5x9fxc4xb1k"] = "xc3x96mer Axc5x9fxc4xb1k"
    playerMap["Goran Dragixc4x87"] = "Goran Dragic"
    playerMap["Miloxc5xa1 Teodosixc4x87"] = "Milos Teodosic"
    playerMap["Mirza Teletovixc4x87"] = "Mirza Teletovic"
    playerMap["Jonas Valanxc4x8dixc5xabnas"] = "Jonas Valanciunas"
    playerMap["Jusuf Nurkixc4x87"] = "Jusuf Nurkic"
    playerMap["MirzaDairis Bertxc4x81ns"] = "Dairis Bertans"
    playerMap["Dario xc5xa0arixc4x87"] = "Dario Saric"
    playerMap["Donatas Motiejxc5xabnas"] = "Donatas Motiejunas"
    playerMap["Dxc4x81vis Bertxc4x81ns"] = "Davis Bertans"
    playerMap["Dxc5xbeanan Musa"] = "Dzanan Musa"
    playerMap["Jakob Pxc3xb6ltl"] = "Jakob Poltl"
    playerMap["Josxe9 Calderxf3n"] = "Jose Calderon"
    playerMap["Kristaps Porzixc5x86xc4xa3is"] = "Kristaps Porzingis"
    playerMap["Luka Donxc4x8dixc4x87"] = "Luka Donic"
    playerMap["Nikola Vuxc4x8devixc4x87"] = "Nikola Vucevic"
    playerMap["Skal Labissixc3xa8re"] = "Skal Labissiere"
    playerMap["Timothxc3xa9 LuwawuCabarrot"] = "Timothe LuwawuCabarrot"
    playerMap["Tomxc3xa1xc5xa1 Satoranskxc3xbd"] = "Tomas Satoransky"
    playerMap["xc1lex Abrines"] = "Alex Abrines"
    playerMap["xc3x81lex Abrines"] = "Alex Abrines"
    playerMap["xc3x81ngel Delgado"] = "Angel Delgado"
    playerMap["xc3x89lie Okobo"] = "Elie Okobo"
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
        teamData = subprocess.check_output(['curl', 'https://www.basketball-reference.com/teams/'], shell = True)
        soup = BeautifulSoup(teamData[10000:], features='html.parser')
        teamDiv = soup.find('div', {'id': 'div_teams_active' })
        teams =  teamDiv.findAll('a')
        for each in teams:
            if re.match('.*<a href="/teams/.*', str(each)):	
                print(each['href'])
                # input()
                ExtractPlayersFromRoster(each['href'], each.text, year, connection, cursor)

# Extract Players from team Roster
def ExtractPlayersFromRoster(teamURL, teamName, year, connection, cursor):
    if teamURL == "/teams/NJN/":
        teamURL = "/teams/BRK/"
    if teamURL == "/teams/CHA/":
        teamURL = "/teams/CHO/"        
    if teamURL == "/teams/NOH/":
        teamURL = "/teams/NOP/"
    

    teamURL = 'https://www.basketball-reference.com' + teamURL + str(year) + '.html' 
    print(teamURL)
    teamRoster = subprocess.check_output(['curl' , teamURL], shell = True)
    teamRoster = str(teamRoster)

    # Sub commented out code
    soup = BeautifulSoup( re.compile("<!--|-->").sub("",teamRoster), features='html.parser')     
    
    teamDiv = soup.find('div', {'id': 'div_roster'})    
    teamPlayers = teamDiv.findAll('tr')

    for i in range(1, len(teamPlayers)):
        position = ""
        player = ""
        playerLink = ""
        player = teamPlayers[i].findAll('td')
        if (len(player) > 0):
            position = player[1].text
            player = player[0]
            playerLink = player.find('a')['href']
            player = player.text
        if len(position) > 0 and len(player) > 0:
            #player = ClearSpecialCharacters(player, True)
            player = re.sub('[^a-zA-Z0-9@\n\.\s]', '', player)    
            player = PlayerUnicodeConversion(player)
            ExtractPlayersData(player, position, playerLink, year, connection, cursor)
            ExtractPlayersAdvancedData(player, position, playerLink, year, connection, cursor)


def ExtractPlayersData(player, playerPosition, playerLink, year, connection, cursor):
    playerLink = playerLink.split('.')[0]    
    if "anderju01" in str(playerLink):        
        return
    playerLink = playerLink.replace('\'', '')
    
    playerLink = playerLink.replace('\\', '')
    playerGameLog = 'https://www.basketball-reference.com' + playerLink + '/gamelog/' + str(year) +'/'        
    playerGameLog = subprocess.check_output(['curl' , playerGameLog], shell = True)
    soup = BeautifulSoup(playerGameLog[10000:], features='html.parser')
    playerGameLogData = soup.find('div', {'id': 'div_pgl_basic'}) 

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
            playerInsert = ("INSERT INTO NBA_Player VALUES (?, ?, ?, ?)")
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
    playerInsertData = ("INSERT INTO NBA_PlayerLog VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
    playerDataTuple = []

    # Body of the Gamelog
    playerGameLogDataBody = playerGameLogData.find('tbody')
    for eachTD in playerGameLogDataBody.findAll('tr'):
        if count == 0:
        #    playerData =  '(\'' + player + '\''  + ',' + '\'' +  playerPosition + '\'' +  ','
            playerDataTuple.append(player)
            playerDataTuple.append(playerPosition)
        else:
        #    playerData =  ',(\'' + player + '\''  + ',' + '\'' +  playerPosition + '\'' +  ','        
            playerDataTuple.append(player)
            playerDataTuple.append(playerPosition)

        #playerData = playerData + '\'' + str(count) + '\'' 
        playerDataTuple.append(count)

        for each in eachTD.findAll('td'):
            #playerData = playerData + ',' + '\'' + ClearSpecialCharacters(each.text, False) + '\''
            playerDataTuple.append(ClearSpecialCharacters(each.text, False))
        # playerData = playerData + ') \n'

        if (len(playerDataTuple) > 15 ):
            dateField = str(playerDataTuple[4])
            dateField = dateField[0:4] + "-" + dateField[4:6] + "-" + dateField[6:8]
            playerDataTuple[4] = dateField
            
            ## Minute Second field
            minField = str(playerDataTuple[11])                        
            if (len(minField) == 4 ):
                minField = int(minField[0:2])*60 + int(minField[2:4])
            else:
                if (len(minField) == 3 ):
                    minField = int(minField[0])*60 + int(minField[0:2]) 
                    
            # print("Final", minField)
            playerDataTuple[11] = minField

            print(tuple(playerDataTuple))
            cursor.execute(playerInsertData, tuple(playerDataTuple))
            cursor.commit()            
            playerDataTuple = []    
            count += 1
        else:
            playerDataTuple = []
            count += 1

    return 0

def ExtractPlayersAdvancedData(player, playerPosition, playerLink, year, connection, cursor):
    playerLink = playerLink.split('.')[0]    
    if "anderju01" in str(playerLink):        
        return
    playerLink = playerLink.replace('\'', '')
    
    playerLink = playerLink.replace('\\', '')
    playerGameLog = 'https://www.basketball-reference.com' + playerLink + '/gamelog-advanced/' + str(year) +'/'        
    playerGameLog = subprocess.check_output(['curl' , playerGameLog], shell = True)
    soup = BeautifulSoup(playerGameLog[10000:], features='html.parser')
    playerGameLogData = soup.find('div', {'id': 'div_pgl_advanced'}) 

    if (playerGameLogData == None):
        return 0

    # Header information for the tables    
    playerGameLogDataHeader = playerGameLogData.find('thead')
    header = {}
    p = inflect.engine()

    # Header Main
    count = 0

    ### DB connection and cleanup
    playerInsertData = ("INSERT INTO NBA_PlayerLog_Advanced VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
    playerDataTuple = []

    # Body of the Gamelog
    playerGameLogDataBody = playerGameLogData.find('tbody')
    for eachTD in playerGameLogDataBody.findAll('tr'):
        if count == 0:
        #    playerData =  '(\'' + player + '\''  + ',' + '\'' +  playerPosition + '\'' +  ','
            playerDataTuple.append(player)
            playerDataTuple.append(playerPosition)
        else:
        #    playerData =  ',(\'' + player + '\''  + ',' + '\'' +  playerPosition + '\'' +  ','        
            playerDataTuple.append(player)
            playerDataTuple.append(playerPosition)

        #playerData = playerData + '\'' + str(count) + '\'' 
        playerDataTuple.append(count)

        for each in eachTD.findAll('td'):
            #playerData = playerData + ',' + '\'' + ClearSpecialCharacters(each.text, False) + '\''
            playerDataTuple.append(ClearSpecialCharacters(each.text, False))
        # playerData = playerData + ') \n'

        if (len(playerDataTuple) > 15 ):
            dateField = str(playerDataTuple[4])
            dateField = dateField[0:4] + "-" + dateField[4:6] + "-" + dateField[6:8]
            playerDataTuple[4] = dateField

            ## Minute Second field
            minField = str(playerDataTuple[11])
            # input(minField)
            if (len(minField) == 4 ):
                print(" min = ", minField[0:2], "Sec = ", minField[2:4])
                minField = int(minField[0:2])*60 + int(minField[2:4])
            else:
                if (len(minField) == 3 ):
                    # print(" min = ", minField[0:1], "Sec = ", minField[0:2])
                    minField = int(minField[0])*60 + int(minField[0:2])

            playerDataTuple[11] = minField
            print(tuple(playerDataTuple))
            cursor.execute(playerInsertData, tuple(playerDataTuple))
            cursor.commit()            
            playerDataTuple = []    
            count += 1
        else:
            playerDataTuple = []
            count += 1

    return 0


ExtractTeams(connection, cursor)