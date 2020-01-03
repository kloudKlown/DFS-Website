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
from datetime import datetime
from bs4 import BeautifulSoup

os.chdir(r"C:\Users\suhas\Source\Repos\kloudKlown\DFS-Website\Python Scripts\NCAA")

dir_path = os.getcwd()
dir_path = "\\".join(dir_path.split("\\")[0:-1]) + "\\chromedriver.exe"
positionHeaders = {}
subprocess.check_output('del NCAA_TodayGames.R', shell = True)
os.remove("../../R Files/NCAA_TodayGames.R")

def ClearSpecialCharacters(data):

    data = data.replace('-','')
    data = data.replace('<a>','')
    data = data.replace('</a>','')
    data = data.replace(' ','')
    return data



fi = open('../../R Files/NCAA_TodayGames.R', 'w+')
fi.write("game1 = c(")
# Extract team urls and names


def ExtractTeams():
    ##############################################################################################################################
    # for year in YEAR:
    month = datetime.now().month
    day = datetime.now().day
    year = datetime.now().year    
    url = 'https://www.sports-reference.com/cbb/boxscores/index.cgi?month=' + str(month) + '&day=' + str(day ) + '&year='+ str(year)
    co = Options()
    co.add_argument("-no-sandbox")
    driver = webdriver.Chrome( options = co, executable_path = dir_path)
    driver.get(url)
    wait = WebDriverWait(driver, 10)
    html = driver.page_source
    # teamData = subprocess.check_output(['curl', url], shell = True)
    soup = BeautifulSoup(html, features='html.parser')
    teamDiv = soup.find('div', {'id': 'all_other_scores' })
    teams =  teamDiv.findAll('a')
    for each in teams:

        if re.match('.*/cbb/sch.*', str(each)):            
            teamName = each['href']
            teamName = teamName.split('/')[3]
            fi.write( '"'+ ClearSpecialCharacters(each.text.lower()) + '",')
        else:
            teamName = str(each)
            print(teamName)            
            fi.write( '"'+ ClearSpecialCharacters(each.text.lower()) + '",')            
    driver.close()
    
ExtractTeams()
fi.write(" \"\" )")
fi.close()