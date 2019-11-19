import sys
import re
from bs4 import BeautifulSoup
import Levenshtein
import pandas as pd 

file = r'FantasyLabs_PlayerMatch.csv'
df = pd.read_csv(file, na_filter= True)

NBARef = [pla for pla in df['NBA Reference'] if (str(pla) != "nan") ]
NBAFB = [pla for pla in df['NBA FB'] if (str(pla) != "nan") ]

f = open("NBA_FB_Player.csv", "a+")

for ref in NBARef:
    ref = ref.lstrip().rstrip()
    Leven = [Levenshtein.ratio(ref, fbP.lstrip().rstrip()) for fbP in NBAFB]
    index = Leven.index(max(Leven))
        
    print(NBAFB[index].lstrip().rstrip(), " ---- " , ref, " ---- " , Leven[index])
    a = NBAFB[index].lstrip().rstrip()
    b = a +"," + ref + "," + str(Leven[index]) + "\n"
    f.write(b)
    




