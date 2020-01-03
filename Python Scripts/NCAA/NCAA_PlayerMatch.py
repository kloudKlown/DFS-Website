import sys
import re
from bs4 import BeautifulSoup
import Levenshtein
import pandas as pd 

file = r'UnmatchedTeams.csv'
df = pd.read_csv(file, na_filter= True)

VegasTeams = [pla for pla in df['Vegas_Teams'] if (str(pla) != "nan") ]
NCAATeam = [pla for pla in df['NCAA_Teams'] if (str(pla) != "nan") ]
usedIndexes = []

f = open("NCAA_Vegas_Mapping.csv", "a+")

for ref in NCAATeam:
    ref = ref.lstrip().rstrip()
    Leven = [Levenshtein.ratio(ref.lower(), fbP.lower().lstrip().rstrip()) for fbP in VegasTeams]
    index = Leven.index(max(Leven))
        
    print(VegasTeams[index].lstrip().rstrip(), " ---- " , ref, " ---- " , Leven[index])
    a = VegasTeams[index].lstrip().rstrip()
    b = a +"," + ref + "," + str(Leven[index]) + "\n"
    f.write(b)
    




