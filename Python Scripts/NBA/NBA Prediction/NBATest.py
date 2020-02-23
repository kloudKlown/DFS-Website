from NBABase import AllStats, TodaysGames, VegasLines, TodaysPlayers

AllStats.columns = ['PlayerName', 'Position', 'Date', 'Team', 'HomeAway', 'Opp', 'Margin', 'MP', 'FG', 'FGA', 'FGper', 'ThreeP',
                    'ThreePA', 'ThreePper', 'FT', 'FTA', 'FTper', 'ORB', 'DRB', 'TRB', 'AST', 'STL', 'BLK', 'TOV', 'PF', 'PTS', 
                    'GmSc', 'TSPer', 'eFGPer', 'ORBPer', 'DRBPer', 'TRBPer', 'ASTPer', 'STLPer', 'BLKPer', 'TOVPer', 'USGPer', 
                    'ORTGPer', 'DRTGPer']

print(list(AllStats.columns))
print(1)