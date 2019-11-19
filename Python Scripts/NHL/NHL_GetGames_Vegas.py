# -*- coding: utf-8 -*-

import sys
import re
from bs4 import BeautifulSoup
import subprocess
from datetime import datetime, timedelta
import pyodbc
import time 
import json

teamDict = { 
            "ANA" : "ANA",
            "ARI" : "ARI",
            "BUF" : "BUF",
            "BOS" : "BOS",
            "CAR" : "CAR",
            "COB" : "CBJ",
            "CGY" : "CGY",
            "CHI" : "CHI",
            "COL" : "COL",
            "DAL" : "DAL",
            "DET" : "DET",
            "EDM" : "EDM",
            "FLA" : "FLA",
            "LOS" : "LAK",
            "MIN" : "MIN",
            "MON" : "MTL",
            "NJD" : "NJD",
            "NAS" : "NSH",
            "NYI" : "NYI",
            "NYR" : "NYR",
            "OTT" : "OTT",
            "PHI" : "PHI",
            "PIT" : "PIT",
            "SAN" : "SJS",
            "STL" : "STL",
            "TAM" : "TBL",
            "TOR" : "TOR",
            "VAN" : "VAN",
            "VGK" : "VEG",
            "WIN" : "WPG",
            "WAS" : "WSH"
}

connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NHL;""Trusted_Connection=yes;")
cursor = connection.cursor()


def GetVegasOdds(dateYear = datetime(2019, 10, 16)):


    dateS = dateYear.day 
    monthS = dateYear.month
    yearS = dateYear.year        
    strDateYear =  str(monthS) + "-" + str(dateS) + "-" + str(yearS)
    print(strDateYear)
    
    cursor.execute("Delete From NHL_Games WHERE GameDate ='" + strDateYear + "';")
    cursor.commit()
    url = "https://www.vegasinsider.com/NHL/scoreboard/" #/scores.cfm/game_date/" + strDateYear
    teamData = subprocess.check_output(['curl', url], shell = True)
    soup = BeautifulSoup(teamData, features='html.parser')
    tds = soup.findAll("td", {"class" : "sportPicksBorder"})    
    for td in tds:                    
            teamList = []
            odds = {}
            odds["line"] = 0
            odds["ou"] = 0
            odds["fv"] = ""
            teams = td.findAll("tr", {"class" : "tanBg"})
            playerInsertData = ("INSERT INTO NHL_Games VALUES (?,?,?,?,?,?)")
            playerDataTuple = []
            playerDataTuple.append(strDateYear)

            for team in teams:
                try:                    
                    team = team.find("a")
                    teamList.append(teamDict[team.text])
                    od = team.parent.next_sibling.next_sibling.next_sibling.next_sibling.text
                    if (od != ""):
                        odds["line"] = float(team.parent.next_sibling.next_sibling.text)
                        if(odds["line"] < 0):
                            odds["fv"] = teamDict[team.text]
                        odds["ou"] = float(od)
                except:
                    continue                    
            if(odds["fv"] == ""):
                odds["fv"] = teamList[1]

            playerDataTuple = playerDataTuple + teamList + list(odds.values())
            print(playerDataTuple, odds)
            cursor.execute(playerInsertData, tuple(playerDataTuple))
            cursor.commit()        

def main(days):

    for i in range(0, int(days[0])):
        dateYear = datetime.today() + timedelta(days = i)  
        GetVegasOdds(dateYear)

if __name__ == '__main__':
    main(sys.argv[1:]) 
