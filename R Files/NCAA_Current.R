setwd("C:/Users/suhas/Source/Repos/kloudKlown/DFS-Website/R Files")
source('RIncludes.R')

TodayDate = Sys.Date()
game1 = c("duke","california","tennesseestate","texastech","southdakotastate","arizona","villanova","middletennessee","xavier","towson","texas","georgetown","ohio","baylor","airforce","loyolamarymount","alabamaa&m","clemson","arkansaspinebluff","pitt","bluefieldstate","northcarolinacentral","buffalo","uconn","ucirvine","tcu","centralmichigan","minnesota","championbaptist","abilenechristian","charlotte","appalachianstate","concord","kentstate","duquesne","indianastate","emerson","hartford","florida","st.joseph's","greenbay","wisconsin","hofstra","ucla","howard","marshall","lamar","utahvalley","lehigh","drake","louisiana","wyoming","marylandeasternshore","oklahoma","medgarevers","st.francisny","mississippistate","tulane","missouristate","miamifl","omaha","washingtonstate","newmexico","newmexicostate","northflorida","iowa","ourladyofthelake","alcornstate","redlands","ucriverside","regent","hampton","robertmorris","uic","st.andrews","uncasheville","sunycortland","colgate","tennesseetech","winthrop","toledo","notredame","utah","coastalcarolina","westerncarolina","jacksonville","william&mary","stanford","wofford","southflorida","youngstownstate","akron")


OffensiveStatsNCAA = read.csv('OffensiveStatsNCAA_All.csv')
DefensiveStatsNCAA = read.csv('DefensiveStatsNCAA_All.csv')
DefensiveStatsNCAA = subset(DefensiveStatsNCAA, select = -X)
OffensiveStatsNCAA = subset(OffensiveStatsNCAA, select = -X)

##########################################

OffensiveStatsNCAA = subset(OffensiveStatsNCAA, as.Date(OffensiveStatsNCAA$Date) < as.Date(TodayDate - 1))
DefensiveStatsNCAA = subset(DefensiveStatsNCAA, as.Date(DefensiveStatsNCAA$Date) < as.Date(TodayDate - 1))

PositionsAll = "G"
### Get Defensive stats for each team
for (eachTeam in unique(AllDataNCAA$School)) {
  # Iterate over each team
  subsetTeamData = subset(AllDataNCAA, AllDataNCAA$School == eachTeam)  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  print(eachTeam)
  ## Iterate over date
  print(TodayDate)
  
  for (pos in as.factor(PositionsAll) ){
    # Iterate over each date
    temp = DefensiveStatsNCAA[1,]
    subsetTeamData = subset(AllDataNCAA, AllDataNCAA$School == eachTeam 
                            & as.Date(AllDataNCAA$Date) < as.Date(TodayDate) &
                              as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 30)
                            & as.character(AllDataNCAA$PlayerPosition) == pos 
    )  
    
    temp$Date = TodayDate
    temp$Tm = eachTeam
    temp$Pos = pos
    #### How good the defense is
    for (column in 4:22){
      temp[, colnames(temp)[column]]  = sum(subsetTeamData[, colnames(temp)[column]])
    }
    
    subsetOppData = subset(AllDataNCAA, AllDataNCAA$School %in% unique(subsetTeamData$Opp) 
                           & as.Date(AllDataNCAA$Date) < as.Date(TodayDate) 
                           & as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 30) &
                             as.character(AllDataNCAA$PlayerPosition) == pos 
    )
    
    #### How many points have been allowed
    for (column in 25:length(colnames(temp)) ){
      print(colnames(temp)[column])
      col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
      
      temp[, colnames(temp)[column]]  = sum(subsetOppData[, col])
      
    }
    
    DefensiveStatsNCAA = rbind(temp, DefensiveStatsNCAA)
  }
  ## Iterate over date
}


allPlayers = unique(subset(AllDataNCAA, as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 30)
                           & AllDataNCAA$School %in% game1))

OffensiveStatsNCAAToday = OffensiveStatsNCAA[0,]
### Get Offensive Stats for each player
for (player in 1:nrow(allPlayers)) {
  player = allPlayers[player,]
  
  ## Get Playerdata
  subsetPlayerData = subset(AllDataNCAA, AllDataNCAA$PlayerName == player$PlayerName & AllDataNCAA$School == player$School)  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  if(player$PlayerName %in% OffensiveStatsNCAAToday$PlayerName){
    next
  }
  print(player$PlayerName)
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$Date , decreasing = FALSE ),]$Date))  
  # Add current Date
  
  ## Iterate over date
  # Iterate over each date
  temp = OffensiveStatsNCAA[1,]
  subsetPlayerData = subset(AllDataNCAA, AllDataNCAA$PlayerName == player$PlayerName & AllDataNCAA$School == player$School 
                            & as.Date(AllDataNCAA$Date) < as.Date(TodayDate) 
                            & as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 300)
  )  
  
  if (nrow(subsetPlayerData) == 0){
    next
  }
  
  lastTeam = as.factor(unique(subsetPlayerData[order(subsetPlayerData$Date , decreasing = FALSE ),]$School))  
  
  lTinGame = (as.character(lastTeam[length(lastTeam)]) %in% game1)
  
  if(lTinGame){
    num = which(as.character(lastTeam[length(lastTeam)]) == game1) 
    if (num %% 2 == 0){
      temp$Opp = game1[num - 1] 
      temp$Home = 1
    }
    else{
      temp$Opp = game1[num + 1]
      temp$Home = 0
    }
    
  }
  else{
    next
  }
  
  
  temp$Date = TodayDate
  temp$PlayerName = player$PlayerName
  temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
  temp$Tm = as.character(lastTeam[length(lastTeam)])
  temp$TotalPoints = 0
  #### How good the defense is
  for (column in 8:length(colnames(temp))){
    temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
  }
  
  OffensiveStatsNCAAToday = rbind(temp, OffensiveStatsNCAAToday)
  ## Iterate over date
}


OffensiveStatsNCAA = rbind(OffensiveStatsNCAAToday , OffensiveStatsNCAA)


########## Combine  Offensive and team defensive stats ####################
TodayDate = Sys.Date() - 5
CombinedStats = merge(OffensiveStatsNCAA, DefensiveStatsNCAA, by.x = c("Date", "Opp"), by.y = c("Date", "Tm" ))
allPlayers = unique(CombinedStats$PlayerName)
DateCheck = TodayDate

Results = data.frame( RFPred = numeric(), player = factor(), position = factor(), salary = numeric(),
                      MP = numeric(), team = factor(), pointsScored = numeric() , assists = numeric(),
                      rebound = numeric(), pointsAllowedAgainstPosition = numeric(),
                      playerList = factor(), TeamScore = numeric(), Actual = numeric(),
                      simpleProjection = numeric(), Opp = numeric())

allPlayers = unique(subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck))$PlayerName)
############################################################
i = 0
for (player in allPlayers){
  i  = i+1
  print(player)
  print(i)
  
  Data_Cleaned_Test = subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck) 
                             & CombinedStats$PlayerName == as.character(player) )
  
  Data_Cleaned_Train = subset(CombinedStats,CombinedStats$PlayerName == as.character(player) &
                                as.Date(CombinedStats$Date) < as.Date(DateCheck)
                              & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 80) )
  
  Data_Cleaned_Train = Data_Cleaned_Train[order(Data_Cleaned_Train$Date , decreasing = TRUE ),]
  
  if(nrow(Data_Cleaned_Train) > 50){
    Data_Cleaned_Train = Data_Cleaned_Train[0:50,]
  }
  
  if (nrow(Data_Cleaned_Train) == 0 | nrow(Data_Cleaned_Test) == 0 ){
    next;
  }
  
  # if (Data_Cleaned_Test$MP < 10 ){
  #   next;
  # }
  
  # "FG.x",   "FGA.x",  "FGper.x","ThreeP.x",   "ThreePA.x", 
  # "ThreePper.x","FT.x",   "FTA.x",  "FTper.x",
  rf = randomForest( Data_Cleaned_Train[,c("MP", "Home","ORB.x", "TRB.x",  "AST.x",  "STL.x",  "BLK.x",  
                                           "TOV.x",  "PF.x", "FG.y", "TRB.y","TOV.y",
                                           "FGAOpp", "ThreePAOpp", "TRBOpp", "ASTOpp", "STLOpp", "BLKOpp")], 
                     y = Data_Cleaned_Train[,c("TotalPoints")], ntree=500, type='regression')
  
  RFPred = predict( rf,  Data_Cleaned_Test[,c("MP","Home",
                                              "ORB.x", "TRB.x",  "AST.x",  "STL.x",  "BLK.x",  "TOV.x",  "PF.x",
                                              "FG.y", "TRB.y","TOV.y","FGAOpp", "ThreePAOpp", "TRBOpp", "ASTOpp", "STLOpp", "BLKOpp")] ,type = c("response") )
  
  
  
  as.data.frame(RFPred)
  
  Prediction2 = as.data.frame(RFPred)
  Prediction2["player"] = player
  Prediction2["position"] = Data_Cleaned_Test$PlayerPosition
  Prediction2["salary"] = Prediction2$RFPred * 1000/5 
  Prediction2["MP"] = Data_Cleaned_Test$MP
  Prediction2["Team"] = Data_Cleaned_Test$Tm
  Prediction2["pointsScored"] = Data_Cleaned_Test$PTS.x
  Prediction2["assists"] = Data_Cleaned_Test$AST.x*1.25 + (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x)*2
  Prediction2["rebound"] = Data_Cleaned_Test$TRB.x*1.5
  Prediction2["TeamScore"] = 0
  Prediction2["Actual"] = Data_Cleaned_Test$TotalPoints
  Prediction2["Opp"] = Data_Cleaned_Test$Opp
  
  # # Get preivous teams against this position ( last 20 days )
  # previousTeams = subset(AllDataNCAA, AllDataNCAA$Opp == as.character(Data_Cleaned_Test$Opp) 
  #                        & as.Date(AllDataNCAA$Date) > (as.Date(DateCheck) - 60)
  #                        & as.Date(AllDataNCAA$Date) < (as.Date(DateCheck))
  #                        & AllDataNCAA$PlayerPosition == Data_Cleaned_Test$PlayerPosition
  #                        & AllDataNCAA$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) - 1)
  #                        & AllDataNCAA$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) + 1)
  # )
  # i = 0
  # 
  # while(nrow(previousTeams) < 4){
  #   i = i + 1
  #   # Get preivous teams against this position ( last 20 days )
  #   previousTeams = subset(AllDataNCAA, AllDataNCAA$Opp == as.character(Data_Cleaned_Test$Opp) 
  #                          & as.Date(AllDataNCAA$Date) > (as.Date(DateCheck) - 60)
  #                          & as.Date(AllDataNCAA$Date) < (as.Date(DateCheck))
  #                          & AllDataNCAA$PlayerPosition == Data_Cleaned_Test$PlayerPosition
  #                          & AllDataNCAA$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) - i*0.5)
  #                          & AllDataNCAA$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x)+ i*0.5)
  #   )
  #   if (i > 10){
  #     break
  #   }
  # }
  # 
  # dataTM = ""
  # 
  # if (nrow(previousTeams) > 0){
  #   for (jk in 1:nrow(previousTeams)) {
  #     datejk = previousTeams$Date[jk]
  #     tm = previousTeams$Tm[jk]
  #     previousTeamData = subset(AllDataNCAA, 
  #                               as.Date(AllDataNCAA$Date) == as.Date(datejk)
  #                               & AllDataNCAA$Tm == tm
  #                               & AllDataNCAA$PTS > previousTeams$PTS[jk] )
  #     dataTM = paste(previousTeamData$PlayerName, '-', previousTeamData$PTS, collapse = '|H|')
  #     previousTeams$PlayerPosition[jk] = dataTM
  #     dataTM = ""
  #   }
  #   
  # }
  # 
  # ####### Previous teams
  # if (nrow(previousTeams) > 0){
  #   Prediction2["playerList"] = paste('=',previousTeams$PlayerName,'-' , previousTeams$PTS, collapse = '||||||')
  #   Prediction2["pointsAllowedAgainstPosition"] = mean(previousTeams$PTS)  
  # }
  # else{
  #   Prediction2["playerList"] = 0
  #   Prediction2["pointsAllowedAgainstPosition"] = 0
  # }
  
  Prediction2["simpleProjection"] = 0
  
  Results = rbind(Results, Prediction2)
  
}
##########
##########

dbSendQuery(con, "Delete From  NCAA_DK_Prediction")
dbWriteTable(con, name = "NCAA_DK_Prediction", value = data.frame(Results), row.names = FALSE, append = TRUE)  

##########
##########
##########

teams = unique(Results$Team)

temp = data.frame(matrix(ncol=1))
NewResults = temp[0,]

for(t in 1:length(teams) ){
  ResTeam = subset(Results, Results$Team == teams[t])
  OppOnent = subset(Results, Results$Team == ResTeam[1,]$Opp)
  
  homeAway = subset(CombinedStats, as.Date(CombinedStats$Date) == (as.Date(TodayDate)) & 
                      ResTeam[1,]$Team == CombinedStats$Tm )
  homeAway = homeAway[1, ]$Home
  ### If homeAway = 0, it means ResTeam was away
  
  if (homeAway == 0){
    ### Playing at opponents team
    LastFewGames = subset(AllDataNCAA, AllDataNCAA$Opp == ResTeam[1,]$Team
                          & as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 60) 
                          & as.Date(AllDataNCAA$Date) < as.Date(TodayDate) 
                          & AllDataNCAA$blank != '@')
  }
  else{
    LastFewGames = subset(AllDataNCAA, AllDataNCAA$Opp == ResTeam[1,]$Team
                          & as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 60) 
                          & as.Date(AllDataNCAA$Date) < as.Date(TodayDate) 
                          & AllDataNCAA$blank == '@')
    
  }
  
  LastFewTeams = length(unique(LastFewGames$School)) 
  
  temp$AveragePointsAllowed = sum(LastFewGames$TotalPoints)/LastFewTeams
  temp$OppFGPer = mean(LastFewGames$FGper)
  temp$OppFGAtt = sum(LastFewGames$FGA)/LastFewTeams
  temp$OppTurnO = sum(LastFewGames$TOV)/LastFewTeams
  temp$OppThreeP = sum(LastFewGames$ThreeP)/LastFewTeams
  
  # Last 30
  
  if (homeAway == 0){
    ### If 0 it means team was away
    LastFewGames = subset(AllDataNCAA, AllDataNCAA$School == ResTeam[1,]$Team
                          & as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 60)  
                          & as.Date(AllDataNCAA$Date) < as.Date(TodayDate)
                          & AllDataNCAA$blank == '@')
  }
  else{
    LastFewGames = subset(AllDataNCAA, AllDataNCAA$School == ResTeam[1,]$Team
                          & as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 60)  
                          & as.Date(AllDataNCAA$Date) < as.Date(TodayDate)
                          & AllDataNCAA$blank != '@')
  }
  
  
  LastFewTeams = length(unique(LastFewGames$Date)) 
  
  temp$AveragePointsScored = sum(LastFewGames$TotalPoints)/LastFewTeams
  temp$OwnFGPer = mean(LastFewGames$FGper)
  temp$OwnFGAtt = sum(LastFewGames$FGA)/LastFewTeams
  temp$OwnTurnO = sum(LastFewGames$TOV)/LastFewTeams
  temp$OwnThreeP = sum(LastFewGames$ThreeP)/LastFewTeams
  
  temp$TotalTeamScore = sum(ResTeam$RFPred)
  temp$OpposingTeamScore = sum(OppOnent$RFPred)
  temp$TOTAL = sum(OppOnent$RFPred) + sum(ResTeam$RFPred)
  temp$TeamMinutes = sum(ResTeam$MP)
  temp$OppMinutes = sum(OppOnent$MP)
  
  temp$Team = ResTeam[1,]$Team
  temp$Opp = ResTeam[1,]$Opp
  
  NewResults = rbind(NewResults, temp)
}

NewResults = subset(NewResults, select = -matrix.ncol...1.)

NewResults[is.na(NewResults)] = 0

dbSendQuery(con, "Delete From  NCAA_DK_Prediction2")
dbWriteTable(con, name = "NCAA_DK_Prediction2", value = data.frame(NewResults), row.names = FALSE, append = TRUE)  


