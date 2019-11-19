import re
import os
import time
import subprocess
from datetime import datetime, timedelta
from bs4 import BeautifulSoup
import inflect 

YEAR = [2019, 2020] 
positionHeaders = {}

subprocess.check_output('del D:\\NBA\\TableInsertNCAA.csv', shell = True)

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
    # print(teamURL)
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
    # print(headerMain)
    
    joinedHaders =  str(','.join(headerMain))
    
    
    joinedHaders = joinedHaders.replace('Opponent,Type,','Opponent,Type,blank2,')    
    # print(joinedHaders)
    # input()
    positionHeaders[playerPosition] = joinedHaders
    fileToWrite = open('D:\\NBA\\TableInsertNCAA.csv', 'a+')
    InsertIntoTable =  'INSERT INTO NCAATABLEDATA ('  + str(joinedHaders) + ') VALUES \n'
    fileToWrite.write(InsertIntoTable) 
    count = 0        

    # Body of the Gamelog
    playerGameLogDataBody = playerGameLogData.find('tbody')
    for eachTD in playerGameLogDataBody.findAll('tr'):
        if count == 0:
            playerData =  '(\'' + player + '\''  + ',' + '\'' +  playerPosition + '\'' +  ','
        else:
            playerData =  ',(\'' + player + '\''  + ',' + '\'' +  playerPosition + '\'' +  ','        
        playerData = playerData + '\'' + str(count) + '\'' 
        for each in eachTD.findAll('td'):
            playerData = playerData + ',' + '\'' + ClearSpecialCharacters(each.text, False) + '\''

        playerData = playerData + ') \n'                   

        if (len(playerData.split(',')) > 15 ):
            print(playerData)
            fileToWrite.write(playerData)
            count += 1

    # input()
    fileToWrite.write(';')
    fileToWrite.close()
    return 0

ExtractTeams()