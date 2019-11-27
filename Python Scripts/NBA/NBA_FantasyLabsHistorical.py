# -*- coding: utf-8 -*-
import sys
import re
from bs4 import BeautifulSoup
import Levenshtein
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import Select

import time
from datetime import datetime, timedelta
import pyodbc
positionHeaders = {}
teamDict = { 
        "ATL" : "ATL",
            "BOS" : "BOS",
            "BKN" : "BRK",
            "CHA" : "CHO",
            "CHI" : "CHI",
            "CLE" : "CLE",
            "DAL" : "DAL",
            "DEN" : "DEN",
            "DET" : "DET",
            "GSW" : "GSW",
            "HOU" : "HOU",
            "IND" : "IND",
            "LAC" : "LAC",
            "LAL" : "LAL",
            "MEM" : "MEM",
            "MIA" : "MIA",
            "MIL" : "MIL",
            "MIN" : "MIN",
            "NOP" : "NOP",
            "NYK" : "NYK",
            "OKC" : "OKC",
            "ORL" : "ORL",
            "PHI" : "PHI",
            "PHX" : "PHO",
            "POR" : "POR",
            "SAC" : "SAC",
            "SAS" : "SAS",
            "TOR" : "TOR",
            "UTA" : "UTA",
            "WAS" : "WAS"
}

def ClearSpecialCharacters(data):
    if '\xa0' in data:        
        data = 'blank'

    if '3' in data and header:
        data = data.replace('3', 'Three')

    data = re.sub('[^a-zA-Z0-9@ \n\.\s]', '', data)
    data = data.replace(' ', '')
    return data


user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3686.68 Safari/537.36'  
### DB connection and cleanup
connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NBA;""Trusted_Connection=yes;")
cursor = connection.cursor()
sqlUpdate = []

# Extract team urls and names
def ExtractTeams(priorDays = 0, dateYear = 0):

    try:
        print("dateYears ", dateYear)        
                  
        def AddZeroToDates(i):
            i = str(i)
            if len(i) == 1:
                return "0" + i
            return i    
        
        time.sleep(4)
        dateS = AddZeroToDates(dateYear.day)
        monthS = AddZeroToDates(dateYear.month)
        yearS = dateYear.year        
        strDateYear =  str(monthS) + str(dateS) + str(yearS)
        strDateYearPrint =  str(yearS) + '-' + str(monthS)  + '-' + str(dateS)
        url = "https://www.fantasylabs.com/nba/player-models/?date=" + strDateYear
        driver.get(url)
        time.sleep(4)

        html = driver.page_source    
        soup = BeautifulSoup(html, features='html.parser')
        playerList = soup.findAll('div', {'class': 'ag-pinned-cols-container'})[0]
        OddPlayers = {}
        cursor.execute("Delete From NBA_FantasyLabs WHERE FL_DateTime ='" + strDateYearPrint + "';")
        cursor.commit()
        i = 0
        for divs in playerList.findAll('div', {'class': 'ag-row ag-row-odd ag-row-level-0'}):
            OddPlayers[i] = []
            sel = 0
            for div in divs.findAll('div'):                
                if sel == 0 and div.find("i", {"class": "fa-check-circle"}) != None:
                    OddPlayers[i].append(1)                    
                    sel = 1
                    continue
                if sel == 0:
                    OddPlayers[i].append(0)
                    sel = 1
                    continue

                OddPlayers[i].append(div.text)            
            i = i + 1
        OddPlayerDetails = {}
        playerDetailsList = soup.findAll('div', {'class': 'ag-body-viewport'})[0]   
        i = 0
        
        for divs in playerDetailsList.findAll('div', {'class': 'ag-row ag-row-odd ag-row-level-0'}):
            OddPlayerDetails[i] = []
            for div in divs.findAll('div'):
                OddPlayerDetails[i].append(div.text)        
            i = i + 1

        for key in OddPlayers.keys():            
            player = (OddPlayers[key][3].split('(')[0]).rstrip().lstrip()            
            player = re.sub('[^a-zA-Z0-9@\n\.\s]', '', player)
            lev = [Levenshtein.ratio(p, player) for p in player]
            index = lev.index(max(lev))
            isSelected = OddPlayers[key][0]
            salary = OddPlayers[key][5].rstrip().lstrip().replace('$', '').replace(',', '')            
            position = OddPlayers[key][4].rstrip().lstrip()
            roster = OddPlayers[key][6].rstrip().lstrip()
            team = OddPlayerDetails[key][0].rstrip().lstrip()
            opp = OddPlayerDetails[key][1].rstrip().lstrip()
            opp = opp.split('-')[0].rstrip().lstrip()
            proj = OddPlayerDetails[key][2].rstrip().lstrip()
            rating = OddPlayers[key][2].rstrip().lstrip()
            actual = OddPlayerDetails[key][12].rstrip().lstrip()   
            team = teamDict[team]         
            
            if actual == "":
                actual = "0"
            playerInsertList = []
            playerInsertList.append(player)
            playerInsertList.append(player)
            playerInsertList.append(salary)
            playerInsertList.append(position)
            playerInsertList.append(roster)
            playerInsertList.append(team)
            playerInsertList.append(opp)
            playerInsertList.append(strDateYearPrint)
            playerInsertList.append(proj)
            playerInsertList.append(rating)
            playerInsertList.append(actual)
            playerInsertList.append(isSelected)
            print(playerInsertList)
            playerInsertData = ("INSERT INTO NBA_FantasyLabs VALUES (?,?,?,?,?,?,?,?,?,?,?,?)")        
            cursor.execute(playerInsertData, tuple(playerInsertList))
            cursor.commit()

        EvenPlayers = {}
        time.sleep(4)
        i = 0
        playerList = soup.findAll('div', {'class': 'ag-pinned-cols-container'})[0]
        for divs in playerList.findAll('div', {'class': 'ag-row ag-row-even ag-row-level-0'}):
            EvenPlayers[i] = []
            sel = 0
            for div in divs.findAll('div'):                
                if sel == 0 and div.find("i", {"class": "fa-check-circle"}) != None:
                    EvenPlayers[i].append(1)                    
                    sel = 1
                    continue

                if sel == 0:
                    EvenPlayers[i].append(0)
                    sel = 1
                    continue
                EvenPlayers[i].append(div.text)            
            i = i + 1

        EvenPlayerDetails = {}
        playerDetailsList = soup.findAll('div', {'class': 'ag-body-viewport'})[0]
        i = 0
        for divs in playerDetailsList.findAll('div', {'class': 'ag-row ag-row-even ag-row-level-0'}):
            EvenPlayerDetails[i] = []
            for div in divs.findAll('div'):
                EvenPlayerDetails[i].append(div.text)        
            i = i + 1
        for key in EvenPlayers.keys():
            player = (EvenPlayers[key][3].split('(')[0]).rstrip().lstrip()
            player = re.sub('[^a-zA-Z0-9@\n\.\s]', '', player)
            lev = [Levenshtein.ratio(p, player) for p in player]
            index = lev.index(max(lev)) 
            isSelected = OddPlayers[key][0]
            salary = EvenPlayers[key][5].rstrip().lstrip().replace('$', '').replace(',', '')
            position = EvenPlayers[key][4].rstrip().lstrip()
            roster = EvenPlayers[key][6].rstrip().lstrip()
            team = EvenPlayerDetails[key][0].rstrip().lstrip()
            opp = EvenPlayerDetails[key][1].rstrip().lstrip()
            opp = opp.split('-')[0].rstrip().lstrip()
            proj = EvenPlayerDetails[key][2].rstrip().lstrip()
            rating = EvenPlayers[key][2].rstrip().lstrip()
            actual = EvenPlayerDetails[key][12].rstrip().lstrip()
            team = teamDict[team]
            
            if actual == "":
                actual = "0"       
            playerInsertList = []
            playerInsertList.append(player)
            playerInsertList.append(player)
            playerInsertList.append(salary)
            playerInsertList.append(position)
            playerInsertList.append(roster)
            playerInsertList.append(team)
            playerInsertList.append(opp)
            playerInsertList.append(strDateYearPrint)
            playerInsertList.append(proj)
            playerInsertList.append(rating)
            playerInsertList.append(actual)
            playerInsertList.append(isSelected)
            print(playerInsertList)
            playerInsertData = ("INSERT INTO NBA_FantasyLabs VALUES (?,?,?,?,?,?,?,?,?,?,?,?)")
            cursor.execute(playerInsertData, tuple(playerInsertList))
            cursor.commit()
            
        time.sleep(4)            
    except Exception:
        
        pass    

url = "https://www.fantasylabs.com/account/login/"
co = Options()
co.add_argument(f'user-agent={user_agent}')
co.add_argument("--window-size=1440,4880")
co.add_argument("--headless")
driver = webdriver.Chrome( options = co, executable_path = "D:\\MLB\\spiders\\chromedriver.exe")

def main(priorDays):    
    driver.get(url)
    email = driver.find_elements_by_xpath("/html/body/div[3]/form[1]/div[2]/div/input")
    email[0].send_keys("suhas.servesh@gmail.com")
    password = driver.find_elements_by_xpath("/html/body/div[3]/form[1]/div[3]/div/input")
    password[0].send_keys("30102996Kross1")
    buttonClick = driver.find_elements_by_xpath("/html/body/div[3]/form[1]/div[4]/button")    
    buttonClick[0].click()    
    #time.sleep(4)
    #driver.get('chrome://settings/')
    #driver.execute_script('chrome.settingsPrivate.setDefaultZoom(0.1);')        
    time.sleep(4)
    if len(priorDays) == 0:
        ExtractTeams()
        return

    for i in range(0, int(priorDays[0])):
        dateYear = datetime.today() - timedelta(days = i)          
        ExtractTeams(i, dateYear)
    driver.close()

if __name__ == "__main__":
   main(sys.argv[1:])   
   

