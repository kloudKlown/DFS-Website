import sys
import re
from bs4 import BeautifulSoup
import Levenshtein
import pandas as pd 

file = r'FantasyLabs_PlayerMatch.csv'
df = pd.read_csv(file, na_filter= True)

nhlRef = [pla for pla in df['NHL Reference'] if (str(pla) != "nan") ]
nhlFB = [pla for pla in df['NHL DK'] if (str(pla) != "nan") ]

f = open("nhl_DK_Player.csv", "a+")

for ref in nhlRef:
    ref = ref.lstrip().rstrip()
    Leven = [Levenshtein.ratio(ref, fbP.lstrip().rstrip()) for fbP in nhlFB]
    index = Leven.index(max(Leven))
        
    print(nhlFB[index].lstrip().rstrip(), " ---- " , ref, " ---- " , Leven[index])
    a = nhlFB[index].lstrip().rstrip()
    b = a +"," + ref + "," + str(Leven[index]) + "\n"
    f.write(b)
    


