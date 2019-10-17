# -*- coding: utf-8 -*-

import sys
import re
import scrapy
from scrapy import Request
from scrapy.spiders.crawl import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor
sys.path.append('../')
from items import JobItem
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
import pyodbc
import hashlib
import time 
import json


def main():
    co = Options()
    driver = webdriver.Chrome( options = co, executable_path = r"D:\\NBA\\NBA\\spiders\\chromedriver.exe")
    driver.get("https://stats.nba.com/players/list/")
    time.sleep(5)
    html = driver.page_source
    soup = BeautifulSoup(html, features= 'html5lib', from_encoding= 'utf-8')
    positions = {}
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

    hrefs = soup.findAll("li", {"class" : "players-list__name"})
    for href in hrefs:        
        if "href=" in str(href.find('a')) and re.match("/player/.*", href.find('a')["href"]):            
            id = str(href.find('a')['href'])
            id = id.split('/')[-2]            
            if ( len(id) > 3 ):
                href = "https://stats.nba.com/stats/shotchartdetail?AheadBehind=&CFID=33&CFPARAMS=2018-19&ClutchTime=&Conference=&ContextFilter=&ContextMeasure=FGA&DateFrom=&DateTo=&Division=&EndPeriod=10&EndRange=28800&GROUP_ID=&GameEventID=&GameID=&GameSegment=&GroupID=&GroupMode=&GroupQuantity=5&LastNGames=0&LeagueID=00&Location=&Month=0&OnOff=&OpponentTeamID=0&Outcome=&PORound=0&Period=0&PlayerID=" + id + "&PlayerID1=&PlayerID2=&PlayerID3=&PlayerID4=&PlayerID5=&PlayerPosition=&PointDiff=&Position=&RangeType=0&RookieYear=&Season=2018-19&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StartPeriod=1&StartRange=0&StarterBench=&TeamID=0&VsConference=&VsDivision=&VsPlayerID1=&VsPlayerID2=&VsPlayerID3=&VsPlayerID4=&VsPlayerID5=&VsTeamID="
                driver.get(href)
                time.sleep(3)
                soup = BeautifulSoup(driver.page_source)
                body = soup.find("body").text                
                dict_from_json = json.loads(body)                
                body = dict_from_json["resultSets"][0]["rowSet"]                
                ### DB connection and cleanup
                connection  = pyodbc.connect("Driver={SQL Server Native Client 11.0};""Server=.;" "Database=NBA;""Trusted_Connection=yes;")
                cursor = connection.cursor()                
                shotData = []                
                playerShot = ("INSERT INTO [NBAShotChart] VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")
                for bodyDetails in body:
                    print(body[0])
                    playerTeam = team[bodyDetails[6]]
                    bodyDetails[6] = str(playerTeam)
                    cursor.execute(playerShot, tuple(bodyDetails))                
                    cursor.commit()
            time.sleep(3)

if __name__ == '__main__':
    main()
