# -*- coding: utf-8 -*-
import os
import sys
import re
from bs4 import BeautifulSoup
import pyodbc
import hashlib
import time 
import json
from seleniumwire import webdriver 
from selenium.webdriver.chrome.options import Options

dir_path = os.getcwd()
dir_path = "\\".join(dir_path.split("\\")[0:-1]) + "\\chromedriver.exe"
team = { 
        "Atlanta Hawks" : "ATL",
            "Boston Celtics" : "BOS",
            "Brooklyn Nets" : "BRK",
            "Charlotte Hornets" : "CHO",
            "Chicago Bulls" : "CHI",
            "Cleveland Cavaliers" : "CLE",
            "Dallas Mavericks" : "DAL",
            "Denver Nuggets" : "DEN",
            "Detroit Pistons" : "DET",
            "Golden State Warriors" : "GSW",
            "Houston Rockets" : "HOU",
            "Indiana Pacers" : "IND",
            "LA Clippers" : "LAC",
            "Los Angeles Lakers" : "LAL",
            "Memphis Grizzlies" : "MEM",
            "Miami Heat" : "MIA",
            "Milwaukee Bucks" : "MIL",
            "Minnesota Timberwolves" : "MIN",
            "New Orleans Pelicans" : "NOP",
            "New York Knicks" : "NYK",
            "Oklahoma City Thunder" : "OKC",
            "Orlando Magic" : "ORL",
            "Philadelphia 76ers" : "PHI",
            "Phoenix Suns" : "PHO",
            "Portland Trail Blazers" : "POR",
            "Sacramento Kings" : "SAC",
            "San Antonio Spurs" : "SAS",
            "Toronto Raptors" : "TOR",
            "Utah Jazz" : "UTA",
            "Washington Wizards" : "WAS"
}

def main():
    co = Options()
    co.add_argument("-no-sandbox")    
    driver = webdriver.Chrome( executable_path = dir_path, options = co)
    driver.get("https://stats.nba.com/players/list/")
    ### DB connection and cleanup
    connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NBA;""Trusted_Connection=yes;")
    cursor = connection.cursor()                
    cursor.execute("Delete From NBAShotChart Where gameDate > '2019-07-01'")                
    cursor.commit()    
    time.sleep(5)    
    html = driver.page_source
    soup = BeautifulSoup(html, features="html.parser")
    positions = {}
    hrefs = soup.findAll("li", {"class" : "players-list__name"})    
    TotalCount = len(hrefs)
    scrapped = 1
    for href in hrefs:        
        if "href=" in str(href.find('a')) and re.match("/player/.*", href.find('a')["href"]):                        
            id = str(href.find('a')['href'])
            id = id.split('/')[-2]                    
            if ( len(id) > 3 ):
                href = "https://stats.nba.com/events/?flag=3&CFID=33&CFPARAMS=2019-20&PlayerID=" + id  + "&ContextMeasure=FGA&Season=2019-20&section=player&sct=plot"
                driver.get(href)
                time.sleep(3)
                pageData = ""
                for request in driver.requests:
                    if request.response and re.match(".*stats.nba.com/stats/shotchartdetail.*", request.path):
                        pageData = request.response.body
                if(pageData == ""):
                    continue
                #soup = BeautifulSoup(pageData, features="html.parser")
                #body = soup.find("body").text                
                dict_from_json = json.loads(pageData)                
                body = dict_from_json["resultSets"][0]["rowSet"]
                shotData = []                
                playerShot = ("INSERT INTO [NBAShotChart] VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
                for bodyDetails in body:                    
                    print("crawling ", href)                
                    print("Completed = ", scrapped, "Out of ", TotalCount)                    
                    playerTeam = team[bodyDetails[6]]
                    bodyDetails[6] = str(playerTeam)
                    cursor.execute(playerShot, tuple(bodyDetails))                
                    cursor.commit()
            time.sleep(3)
            scrapped = scrapped + 1

if __name__ == '__main__':
    main()