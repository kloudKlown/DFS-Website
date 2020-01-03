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
            "ANA" : "ANA",
            "ARI" : "ARI",
            "BUF" : "BUF",
            "BOS" : "BOS",
            "CAR" : "CAR",
            "CBJ" : "CBJ",
            "CGY" : "CGY",
            "CHI" : "CHI",
            "COL" : "COL",
            "DAL" : "DAL",
            "DET" : "DET",
            "EDM" : "EDM",
            "FLA" : "FLA",
            "LAK" : "LAK",
            "MIN" : "MIN",
            "MON" : "MTL",
            "NJD" : "NJD",
            "NSH" : "NSH",
            "NYI" : "NYI",
            "NYR" : "NYR",
            "OTT" : "OTT",
            "PHI" : "PHI",
            "PIT" : "PIT",
            "SJS" : "SJS",
            "STL" : "STL",
            "TBL" : "TBL",
            "TOR" : "TOR",
            "VAN" : "VAN",
            "VGK" : "VEG",
            "WPG" : "WPG",
            "WSH" : "WSH"
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
connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NHL;""Trusted_Connection=yes;")
cursor = connection.cursor()
sqlUpdate = []


def ExtractPlayers(strDateYearPrint):
    try:
        html = driver.page_source
        soup = BeautifulSoup(html, features='html.parser')
        playerList = soup.findAll('div', {'class': 'fixedDataTableLayout_rowsContainer'})[0]        
        OddPlayers = {}
        i = 0
        
        for divs in playerList.findAll('div', {'class': 'fixedDataTableRowLayout_rowWrapper'}):            
            if ("Player" in divs.text):
                continue
            if ("Name" in divs.text):
                continue
            OddPlayers[i] = []
            for player in divs.findAll("div", {"class": "fixedDataTableCellLayout_main public_fixedDataTableCell_main"}):
                OddPlayers[i].append(player.text)
            i = i + 1        

        for key in OddPlayers.keys():            
            player = OddPlayers[key][0].rstrip().lstrip()            
            player = re.sub('[^a-zA-Z0-9@\n\.\s]', '', player)            
            salary = float(OddPlayers[key][1].rstrip().lstrip().replace('$', '').replace('K', ''))
            salary =  salary * 1000
            position = OddPlayers[key][2].rstrip().lstrip()            
            team = OddPlayers[key][3].rstrip().lstrip()
            opp = OddPlayers[key][4].replace("vs ", "").rstrip().lstrip()
            opp = opp.replace("@", "").rstrip().lstrip()
            vegasTotal = OddPlayers[key][8].rstrip().lstrip()
            vegasT = OddPlayers[key][9].rstrip().lstrip()
            line = OddPlayers[key][10].rstrip().lstrip()
            pp = OddPlayers[key][11].rstrip().lstrip()
            
            team = teamDict[team]            
            playerInsertList = []
            playerInsertList.append(player)
            playerInsertList.append(salary)
            playerInsertList.append(position)
            playerInsertList.append(team)
            playerInsertList.append(opp)
            playerInsertList.append(strDateYearPrint)
            playerInsertList.append(vegasTotal)
            playerInsertList.append(vegasT)
            playerInsertList.append(line)
            playerInsertList.append(pp)
            print(playerInsertList)
            playerInsertData = ("INSERT INTO NHL_FantasyLabs VALUES (?,?,?,?,?,?,?,?,?,?)") 
            cursor.execute(playerInsertData, tuple(playerInsertList))
            cursor.commit()        
        return 1

    except :
        pass


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
        url = "https://rotogrinders.com/lineuphq/nhl?site=draftkings&date=" + strDateYearPrint
        driver.get(url)
        time.sleep(4)
       
        cursor.execute("Delete From NHL_FantasyLabs WHERE FL_DateTime ='" + strDateYearPrint + "';")
        cursor.commit()
        # Get strikers
        bClass = driver.find_elements_by_class_name("lhq-filter__button")
        bClass[0].click()
        ExtractPlayers(strDateYearPrint)         
        
        # Get Goalies
        bClass[1].click()
        ExtractPlayers(strDateYearPrint)       

    except Exception:           
        pass    


url = "https://rotogrinders.com/sign-in"
co = Options()
co.add_argument(f'user-agent={user_agent}')
co.add_argument("--window-size=1440,15000")
co.add_argument("--headless")
driver = webdriver.Chrome( options = co, executable_path = "D:\\MLB\\spiders\\chromedriver.exe")

def main(priorDays):    
    driver.get(url)
    email = driver.find_elements_by_xpath("//*[@id=\"username\"]")
    email[0].send_keys("gotftw51@gmail.com")
    password = driver.find_elements_by_xpath("//*[@id=\"password\"]")
    password[0].send_keys("ilovepanda123")
    buttonClick = driver.find_elements_by_xpath("//*[@id=\"top\"]/div/section/div/section/div/div/div[2]/form/input[5]")
    buttonClick[0].click()

    # time.sleep(4)
    # driver.get('chrome://settings/')
    # driver.execute_script('chrome.settingsPrivate.setDefaultZoom(0.1);')

    if len(priorDays) == 0:
        ExtractTeams()
        return

    for i in range(0, int(priorDays[0])):
        dateYear = datetime.today() - timedelta(days = i)          
        ExtractTeams(i, dateYear)
    driver.close()

if __name__ == "__main__":
   main(sys.argv[1:])   

