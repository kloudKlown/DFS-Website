# -*- coding: utf-8 -*-

import sys
import re
from bs4 import BeautifulSoup
import subprocess
from datetime import datetime, timedelta
import pyodbc
import time 

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
            "NOR" : "NOP",
            "NYK" : "NYK",
            "OKC" : "OKC",
            "ORL" : "ORL",
            "PHI" : "PHI",
            "PHO" : "PHO",
            "POR" : "POR",
            "SAC" : "SAC",
            "SAS" : "SAS",
            "TOR" : "TOR",
            "UTH" : "UTA",
            "WAS" : "WAS"
}

connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NBA;""Trusted_Connection=yes;")
cursor = connection.cursor()


def ClearSpecialCharacters(data):

    data = data.replace('-','')
    data = data.replace('<a>','')
    data = data.replace('</a>','')
    data = data.replace(' ','')
    return data

def GetVegasOdds(dateYear = datetime(2019, 10, 16)):
    dateS = dateYear.day 
    monthS = dateYear.month
    yearS = dateYear.year        
    strDateYear =  str(monthS) + "-" + str(dateS) + "-" + str(yearS)
    print(strDateYear)
    
    cursor.execute("Delete From NCAA_Games WHERE GameDate ='" + strDateYear + "';")
    cursor.commit()
    url = "https://www.vegasinsider.com/college-basketball/scoreboard/"#scores.cfm/game_date/" + strDateYear
    teamData = subprocess.check_output(['curl', url], shell = True)
    soup = BeautifulSoup(teamData, features='html.parser')
    tds = soup.findAll("td", {"class" : "scoreBoardPanelCell"})    
    
    try:
        for td in tds:            
            teamList = []
            odds = {}
            odds["line"] = 0
            odds["ou"] = 0
            odds["fv"] = ""            
            teams = td.findAll("td", {"class" : "tanBg"})
            playerInsertData = ("INSERT INTO NCAA_Games VALUES (?,?,?,?,?,?)")
            playerDataTuple = []
            playerDataTuple.append(strDateYear)
            
            for team in teams:                
                school = team.find("a")['href']                
                teamList.append(ClearSpecialCharacters(school.split('/')[-1]))
                od = team.next_sibling.next_sibling.text
                playerOpp = team.parent.next_sibling.next_sibling                
                schoolOpp = playerOpp.find("a")['href']                
                teamList.append(ClearSpecialCharacters(schoolOpp.split('/')[-1]))                
                odOpp = playerOpp.find("a").parent.next_sibling.next_sibling.text
                                
                if "PK" in odOpp:
                    odOpp = 0
                if (float(odOpp) < 100):
                    odds["line"] = float(odOpp)
                    odds["fv"] = ClearSpecialCharacters(schoolOpp.split('/')[-1])
                else:
                    odds["ou"] = float(odOpp)
                
                if "PK" in od:
                    od = 0
                    
                if (float(od) < 100):
                    odds["line"] = float(od)
                    odds["fv"] = ClearSpecialCharacters(school.split('/')[-1])
                else:
                    odds["ou"] = float(od)                
                break
            
            playerDataTuple = playerDataTuple + teamList + list(odds.values())
            print(playerDataTuple, odds)
            cursor.execute(playerInsertData, tuple(playerDataTuple))
            cursor.commit()        
    except:
        pass
        
def main(days):
    for i in range(0, int(days[0])):
        dateYear = datetime.today() + timedelta(days = i)  
        GetVegasOdds(dateYear)

if __name__ == '__main__':
    main(sys.argv[1:]) 
