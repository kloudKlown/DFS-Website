# -*- coding: utf-8 -*-

import sys
import os
import re
import subprocess
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
import pyodbc
import hashlib
import time
sys.path.append('../')
import PlayerClass
from datetime import datetime
from bs4 import BeautifulSoup


MainUrl = "http://www.espn.com/golf/players"
connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=Golf;""Trusted_Connection=yes;")
cursor = connection.cursor()

PlayerList = {}
cursor.execute('Select PlayerName from Golf_Player')

for each in cursor.fetchall():
    try:
        PlayerList[each.PlayerName] = 1
    finally:
        pass


def Player(url):    
    teamData = subprocess.check_output(['curl', url], shell = True)
    soup = BeautifulSoup(teamData, features='html.parser')
    player = soup.find("div", {"class": "mod-page-header"})
    if (player == None):
        return 0
    player = player.find("h1")
    playerID = url.split("id/")[-1]
    playerID = playerID.split("/")[0]
    
    
    try:
        if(PlayerList[player.text] == 1):                
            pass
    except:        
        playerInsert = ("INSERT INTO Golf_Player VALUES (?,?)")
        playerData = [player.text, playerID]        
        cursor.execute(playerInsert, tuple(playerData))
        cursor.commit()
    return 1

def GetScorecards(url, tournamentID, years):

    try:
        playerID = url.split("id/")[-1]
        playerID = playerID.split("/")[0]
        teamData = subprocess.check_output(['curl', url], shell = True)
        soup = BeautifulSoup(teamData, features='html.parser')
        scorecards = soup.findAll("div", {"class": "mod-container mod-table mod-no-header-footer mod-player-stats"})
        stats = soup.findAll("div", {"class": "mod-container mod-table mod-no-footer mod-player-stats"})

        #################################################################################################
        ## Player Stats ##
        if(stats != None):
            stats = stats[0].find("tr", {"class": "oddrow"})            
            playerInsert = ("INSERT INTO Golf_PlayerStats VALUES (?,?,?,?,?,?,?,?,?,?)")
            playerData = [int(playerID),int(tournamentID), years]            
            for each in stats.findAll("td"):                
                try:
                    playerData.append(float(each.text))
                except:
                    playerData.append(0)            
            cursor.execute(playerInsert, tuple(playerData))
            cursor.commit()            

        scorecards = scorecards[-1].findAll("div", {"class" : "roundSwap"})        
        roundID = 1
        print(len(scorecards), url)
        playerInsert = ("INSERT INTO Golf_PlayerLog VALUES (?,?,?,?,?,?,?,?)")
        #################################################################################################
        ## Player Logs ##

        for each in scorecards:        
            colheads = each.findAll("tr", {"class": "colhead"})
            ScoresCollected = []
            
            ### Scores Col Heads
            for heads in colheads:
                scores = heads.findAll("td", {"class" : "textcenter"})
                i = 0

                ### Scores TextCenter
                for score in scores:
                    S = {}
                    try:
                        score = int(score.text)
                        score = str(score)     
                        S["Par"] = score[-1]
                        S["Yards"] = score[-4:-1]
                        S["Hole"] = score[0:len(score)-4]
                        ScoresCollected.append(S)
                        i = i + 1
                    except:
                        continue
        
            oddrows = each.findAll("tr", {"class": "oddrow"})
            ShotCollected = []

            ### Scores Shots
            for heads in oddrows:
                scores = heads.findAll("td", {"class" : "textcenter"})
                i = 0

                ### Shots
                for score in scores:
                    try:
                        score = int(score.text)
                        if (score > 10):
                            continue
                        score = str(score)             
                        ShotCollected.append(score)
                        i = i + 1
                    except:
                        continue        
            
            i = 0    
            try:
                for score in ScoresCollected:            
                    playerData = [playerID, tournamentID, years, roundID, score["Hole"], score["Yards"], score["Par"], ShotCollected[i]]
                    cursor.execute(playerInsert, tuple(playerData))
                    cursor.commit()
                    i = i + 1
                            
                roundID = roundID + 1
            except :
                return 0    
    except Exception:

        pass


def GetTournamets(url, years):
    teamData = subprocess.check_output(['curl', url], shell = True)
    soup = BeautifulSoup(teamData, features='html.parser')
    tournaments = soup.find("div", {"class": "select-container"})
    if (tournaments == None):
        return 0
    tournaments = tournaments.findAll("select")
    tournaments = tournaments[-1].findAll("option")
    print(tournaments)

    for each in tournaments[1:]:
        if "tournamentId" in each["value"]:
            print(each)
            tournamentID = each["value"].split("tournamentId/")[-1]   
            GetScorecards(each["value"][2:], tournamentID, years)            


def GetYears(url):
    teamData = subprocess.check_output(['curl', url], shell = True)
    soup = BeautifulSoup(teamData, features='html.parser')
    scorecards = soup.find("div", {"class": "select-container"})
    scorecards = scorecards.findAll("select")
    scorecards = scorecards[0].findAll("option")
    if (len(scorecards) > 2):
        years = int(scorecards[1].text)
    else:
        return 0
    print(scorecards)
        
    for each in scorecards[1:]:
        if (years < 2016):
            break        
        
        if "scorecards" in each["value"] and "year" not in each["value"]:
            eachUrl = each["value"][2:] + "/year/" + str(years)
            GetTournamets(eachUrl, years)            

        if "year" in each["value"]:            
            GetTournamets(each["value"][2:], years)

        years = years - 1

def ExtractPlayers():
    teamData = subprocess.check_output(['curl', MainUrl], shell = True)
    soup = BeautifulSoup(teamData, features='html.parser')    
    linkList = ["http://www.espn.com/golf/player/scorecards/_/id/" + str(x) for x in range(1, 11450)]    

    for each in linkList:        
        r = Player(each)
        if (r == 1):
            GetYears(each)           

ExtractPlayers()