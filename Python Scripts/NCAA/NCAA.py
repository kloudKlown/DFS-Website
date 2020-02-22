import re
import os
import time
import subprocess
from datetime import datetime, timedelta
from bs4 import BeautifulSoup
import inflect 
import pyodbc

YEAR = [2020] 
positionHeaders = {}
connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NBA;""Trusted_Connection=yes;")
cursor = connection.cursor()
cursor.execute("Delete from NCAA_PlayerLog Where [Date] > '2019-07-01'")
cursor.commit()

PlayerList = {}
cursor.execute('Select PlayerName from NCAA_Player')
for each in cursor.fetchall():
    try:
        PlayerList[each.PlayerName.lower()] = 1
    finally:
        pass

def ClearSpecialCharacters(data, header):
    if header:
        data = data.replace('%', 'per')

    if '\xa0' in data:        
        data = 'blank'

    if '3' in data and header:
        data = data.replace('3', 'Three')

    data = re.sub('[^a-zA-Z0-9 \n\.\s@]', '', data)
    data = data.replace(' ', '')
    return data


# Extract team urls and names
def ExtractTeams():
    for year in YEAR:
        teamData = subprocess.check_output(['curl', 'https://www.sports-reference.com/cbb/schools/'], shell = True)
        soup = BeautifulSoup(teamData[10000:], features='html.parser')
        teamDiv = soup.find('table', {'id': 'schools' })
        teams =  teamDiv.findAll('a')
        # print(teams[0])
        # input()
        for each in teams:
            if re.match('.*<a href="/cbb/.*', str(each)):	
                print(each['href'])
                # input()
                ExtractPlayersFromRoster(each['href'], each.text, year)

# Extract Players from team Roster
def ExtractPlayersFromRoster(teamURL, teamName, year):
    # NJN -> BRK
    # CHA -> CHO   
    # NOH -> NOP

    teamURL = 'https://www.sports-reference.com' + teamURL + str(year) + '.html' 
    print(teamURL)
    teamRoster = subprocess.check_output(['curl' , teamURL], shell = True)
    teamRoster = str(teamRoster)
    # Sub commented out code
    soup = BeautifulSoup( re.compile("<!--|-->").sub("",teamRoster), features='html.parser')     
    
    teamDiv = soup.find('div', {'id': 'all_roster'})    
    if (teamDiv == None):
        return

    teamPlayers = teamDiv.findAll('tr')

    if (teamPlayers == None):
        return 

    for i in range(1, len(teamPlayers)):
        position = ""
        player = ""
        playerLink = ""
        player = teamPlayers[i].findAll('th')
        if (len(player) > 0):
            print(player)
            playerLink = player[0].find('a')['href']
            player = player[0].text
        if len(playerLink) > 0:
            print(player, position, playerLink)
            # input()
            player = ClearSpecialCharacters(player, True)
            ExtractPlayersData(player, "G", playerLink, year)



def ExtractPlayersData(player, playerPosition, playerLink, year):
    playerLink = playerLink.split('.')[0]    
    if "anderju01" in str(playerLink):        
        return
    playerLink = playerLink.replace('\'', '')
    
    playerLink = playerLink.replace('\\', '')
    playerGameLog = 'https://www.sports-reference.com' + playerLink + '/gamelog/' + str(year) +'/'        
    playerGameLog = subprocess.check_output(['curl' , playerGameLog], shell = True)
    soup = BeautifulSoup(playerGameLog[10000:], features='html.parser')
    playerGameLogData = soup.find('div', {'id': 'all_gamelog'}) 

    WH = soup.find("span", {'itemprop' : 'weight'})

    if (WH != None):
        height, weight = str(WH.next_sibling).split(',')        
        height = re.sub('[^a-zA-Z0-9@\n\.\s]', '', height).replace('cm', '')
        weight = re.sub('[^a-zA-Z0-9@\n\.\s]', '', weight).replace('kg', '')
        try:
            if(PlayerList[player.lower()] == 1):                
                pass
        except KeyError as e:
            playerInsert = ("INSERT INTO NCAA_Player VALUES (?, ?, ?, ?)")
            playerData = [player, playerPosition, int(height), int(weight)]
            cursor.execute(playerInsert, tuple(playerData))
            print(tuple(playerData))
            cursor.commit()
            PlayerList[player.lower()] = 1
            pass        

    if (playerGameLogData == None):
        return 0
    # Header information for the tables    
    playerGameLogDataHeader = playerGameLogData.find('thead')
    header = {}
    p = inflect.engine()

    # Header Titles
    if (len(playerGameLogDataHeader.findAll('tr')) > 0):
        colSpan = 0        
        for eachHeader in (playerGameLogDataHeader.findAll('tr')[0]).findAll('th'):
                headerName = ""
                
                if (len(str(eachHeader.text)) > 0):
                    headerName = ClearSpecialCharacters(eachHeader.text, True)
                    # print(headerName)

                else:
                    length = p.number_to_words(len(header) + 1)
                    headerName = length

                header[headerName] = headerName
                # print(eachHeader, eachHeader.text)
                if ('colspan' in str(eachHeader)):
                        colSpan = colSpan + int(eachHeader['colspan'])
                        header[headerName] = colSpan
    
    # Header Main
    headerMain = []

    # Combine headers
    for k in header.keys():
        # print(header[k])
        headerMain.append(header[k])

    headerMain[-1] = 'plusMinus'
    headerMain.insert(0, "PlayerPosition")
    headerMain.insert(0, "PlayerName")        
    joinedHaders =  str(','.join(headerMain))

    ### DB connection and cleanup
    playerInsertData = ("INSERT INTO [NCAA_PlayerLog] VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
    playerDataTuple = []

    
    joinedHaders = joinedHaders.replace('Opponent,Type,','Opponent,Type,blank2,')
    positionHeaders[playerPosition] = joinedHaders
    count = 0        

    # Body of the Gamelog
    playerGameLogDataBody = playerGameLogData.find('tbody')
    for eachTD in playerGameLogDataBody.findAll('tr'):
        playerDataTuple.append(player)
        playerDataTuple.append(playerPosition)
        playerDataTuple.append(count)

        # if count == 0:
        #     playerData =  '(\'' + player + '\''  + ',' + '\'' +  playerPosition + '\'' +  ','
        # else:
        #     playerData =  ',(\'' + player + '\''  + ',' + '\'' +  playerPosition + '\'' +  ','        
        # playerData = playerData + '\'' + str(count) + '\'' 
        
        for each in eachTD.findAll('td'):
            data = ClearSpecialCharacters(each.text, False)
            try:
                data = int(data)
                playerDataTuple.append(data)
                continue
            except:
                pass

            try:
                data = float(data)
                playerDataTuple.append(data)
                continue
            except:
                pass
            
            if (len(data) == 0):
                playerDataTuple.append(0)
                continue

            playerDataTuple.append(data)
            #playerData = playerData + ',' + '\'' + ClearSpecialCharacters(each.text, False) + '\''

        #playerData = playerData + ') \n'                   

        if (len(playerDataTuple) > 15 ):                
            dateField = str(playerDataTuple[3])[0:4] + "-" + str(playerDataTuple[3])[4:6] + "-" + str(playerDataTuple[3])[6:8]
            playerDataTuple[3] = dateField  
            playerDataTuple[5] = str(playerDataTuple[5])            
            cursor.execute(playerInsertData, tuple(playerDataTuple))
            cursor.commit()                 
            print("playerDataTuple Value = ", playerDataTuple) 
            playerDataTuple = []            
            count += 1    
    return 0

ExtractTeams()