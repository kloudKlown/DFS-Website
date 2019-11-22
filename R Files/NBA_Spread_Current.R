library(Hmisc)
library(corrplot)
library(brnn)
library(h2o)
library(randomForest)
library(Matrix)
# library(xgboost)
library(stringdist)
library(varhandle)
library(tidyr)
require(devtools)
# library(mxnet)
setwd("D:/NBA")
source('NBA_getDBData.R')

NBATableData = NBATableData[,c("PlayerName","Position","Date","Team","blank","Opp","blank2","MP",
                               "FG","FGA","FGper","ThreeP","ThreePA","ThreePper",
                               "FT","FTA","FTper","ORB","DRB","TRB","AST","STL",
                               "BLK","TOV","PF","PTS","GmSc",
                               "TSPer","eFGPer","ORBPer","DRBPer","TRBPer","ASTPer",
                               "STLPer","BLKPer","TOVPer","USGPer","ORTGPer","DRTGPer")]


NBAAllData = NBATableData

OffensiveStats = read.csv('OffensiveStats_All.csv')
DefensiveStats = read.csv('DefensiveStats_All.csv')

#OffensiveStats = subset(OffensiveStats, select = -X)
OffensiveStats = subset(OffensiveStats, select = -X.1)

#DefensiveStats = subset(DefensiveStats, select = -X)
DefensiveStats = subset(DefensiveStats, select = -X.1)

######################################################
############### Team Defensive stats ######################
######################################################
DefensiveStatsNew = DefensiveStats[0,]


PositionsAll = unique(NBAAllData$Position)
Teams = unique(NBAAllData$Team)


### Get Defensive stats for each team
for (eachTeam in Teams) {
  # Iterate over each team
  subsetTeamData = subset(NBAAllData, NBAAllData$Team == eachTeam)  
  
  DefensiveStatsMaxDate = max(as.Date(subset(DefensiveStats, DefensiveStats$Tm == eachTeam)$Date ), na.rm =  TRUE)  
  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetTeamData[order(subsetTeamData$Date , decreasing = FALSE ),]$Date))
  
  DateLevels = DateLevels[as.Date(DateLevels) > DefensiveStatsMaxDate]
  if (length(DateLevels) == 0){
    next;
  }
  #############################
  ### Position######
  ## Iterate over date
  for (date in 1:length(DateLevels)){
    print(paste("Team = ", eachTeam, " level " ,length(DateLevels)/date))
    
    for (pos in as.factor(PositionsAll) ){
      # Iterate over each date
      temp = DefensiveStatsNew[1,]
      ## Make sure do not include this date but eveytyhing before.
      subsetTeamData = subset(NBAAllData, NBAAllData$Team == eachTeam 
                              & as.Date(NBAAllData$Date) < as.Date(DateLevels[date]) &
                                as.Date(NBAAllData$Date) > (as.Date(DateLevels[date]) - 300) &
                                as.character(NBAAllData$Position) == pos )
      subsetTeamData = subsetTeamData[order(subsetTeamData$Date , decreasing = TRUE ),]

      currentGame = subset(NBAAllData, NBAAllData$Team == eachTeam 
                           & as.Date(NBAAllData$Date) == as.Date(DateLevels[date]) &
                             as.character(NBAAllData$Position) == pos )
      subsetTeamData = subsetTeamData[subsetTeamData$PlayerName %in% currentGame$PlayerName,] 
      if(nrow(subsetTeamData) > 50){
        subsetTeamData = subsetTeamData[0:50,]
      }
            
      if(nrow(subsetTeamData) == 0){
        next;
      }
      
      temp$Date = DateLevels[date]
      temp$Tm = eachTeam
      temp$Pos = pos
      
      #### How does team perform in this position historically
      for (column in 4:31){
        print(colnames(temp)[column])
        temp[, colnames(temp)[column]]  = mean(subsetTeamData[, colnames(temp)[column]])
      }
      
      ### Get Opposition Players in the game
      OppPositionPlayers = unique(subset(NBAAllData, NBAAllData$Team == currentGame$Opp[1]
                                & as.Date(NBAAllData$Date) == as.Date(DateLevels[date])
                                 & as.character(NBAAllData$Position) == pos)$PlayerName)
      
      ### Get Opposition Players and their dates to find all games these players particiated in
      
      OppositionTeams = unique(subset(NBAAllData, NBAAllData$PlayerName %in% OppPositionPlayers)$Opp)
      OppositionDates = unique(subset(NBAAllData, NBAAllData$PlayerName %in% OppPositionPlayers)$Date)
      ## Make sure do not include this date but eveytyhing before.
      subsetOppData = subset(NBAAllData, NBAAllData$Team %in% unique(OppositionTeams) 
                             & as.Date(NBAAllData$Date) < as.Date(DateLevels[date]) 
                             & as.Date(NBAAllData$Date) %in% (as.Date(OppositionDates))
                             & as.character(NBAAllData$Position) == pos)
      subsetOppData = subsetOppData[order(subsetOppData$Date , decreasing = TRUE ),]
      if(nrow(subsetOppData) > 50){
        subsetOppData = subsetOppData[0:50,]
      }
      
      #### How many points have been allowed
      for (column in 31:length(colnames(temp)) ){
        #print(colnames(temp)[column])
        col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
        
        temp[, colnames(temp)[column]]  = mean(subsetOppData[, col])
      }
      
      DefensiveStatsNew = rbind(temp, DefensiveStatsNew)
    }
    
  }
}


######################################################
############### Player stats ######################
######################################################
######### Offensive Stats
OffensiveStatsNew = data.frame(matrix(ncol=38))
colnames(OffensiveStatsNew) = c("PlayerName", "Tm", "PlayerPosition" , "Date", "Opp",  "TotalPoints","DKP",
                             "Home","MP",
                             "FG","FGA","ThreeP","ThreePA","FT","FTA","ORB","DRB",
                             "TRB","AST","STL","BLK","TOV","PF","TSPer","eFGPer","ORBPer",
                             "DRBPer","TRBPer","ASTPer","STLPer","BLKPer","TOVPer","USGPer","ORTGPer","DRTGPer",
                             "OppPosDRTPer", "OppTeamDRTGPer", "OppTeamORTGPer")

NBAAllData$TotalPoints = NBAAllData$PTS
NBAAllData$DKP = NBAAllData$FT * 1 + (NBAAllData$FG-NBAAllData$ThreeP) * 2 + NBAAllData$ThreeP * 3.5 + NBAAllData$AST * 1.5 +
NBAAllData$TRB * 1.25 + NBAAllData$STL * 2 + NBAAllData$BLK * 2 - NBAAllData$TOV * 0.5

allPlayers = unique(NBAAllData$PlayerName)

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(NBAAllData, NBAAllData$PlayerName == player)  
  DefensiveStatsMaxDate = max(as.Date(subset(OffensiveStats, OffensiveStats$PlayerName == player)$Date ), na.rm =  TRUE)  
  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$Date , decreasing = FALSE ),]$Date))
  
  DateLevels = DateLevels[as.Date(DateLevels) > DefensiveStatsMaxDate]
  if (length(DateLevels) == 0){
    next;
  }  
  # Add current Date
  # DateLevels = factor(c(levels(DateLevels),substring(Sys.time(),0,10)))
  print(player)
  ## Iterate over date
  for (date in 2:length(DateLevels)){
    # Iterate over each date
    temp = OffensiveStatsNew[1,]
    subsetPlayerData = subset(NBAAllData, NBAAllData$PlayerName == player 
                              & as.Date(NBAAllData$Date) < as.Date(DateLevels[date]) 
                              & as.Date(NBAAllData$Date) > (as.Date(DateLevels[date]) - 300)
    )  
    subsetPlayerData = subsetPlayerData[order(subsetPlayerData$Date , decreasing = TRUE ),]
    if(nrow(subsetPlayerData) > 50){
      subsetPlayerData = subsetPlayerData[0:50,]
    }
    
    currentGame = subset(NBAAllData, NBAAllData$PlayerName == player 
                         & as.Date(NBAAllData$Date) == as.Date(DateLevels[date])) 
    
    if (nrow(currentGame) == 0 ){
      next
    }
    
    temp$Date = DateLevels[date]
    temp$PlayerName = player
    temp$PlayerPosition = as.character(subsetPlayerData$Position[1])
    temp$Tm = as.character(subsetPlayerData$Team[1])
    temp$Opp = as.character(currentGame$Opp[1])     
    temp$MP = mean(as.numeric(subsetPlayerData$MP))/60
    if (currentGame$blank == '@' | currentGame$blank == 'N'){
      temp$Home = 0
    }
    else{
      temp$Home = 1
    }
    
    #### How good the player is last 30 days
    for (column in 10:(length(colnames(temp)) - 3) ){
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    ### Opposing Team stats
    currentOppPlayers = unique(subset(NBAAllData, NBAAllData$Team == currentGame$Opp 
                                      & as.Date(NBAAllData$Date) == as.Date(DateLevels[date]))$PlayerName) 
    
    currentOppPlayers = subset(NBAAllData, NBAAllData$PlayerName %in% currentOppPlayers 
                               & as.Date(NBAAllData$Date) < as.Date(DateLevels[date])
                               & as.Date(NBAAllData$Date) > (as.Date(DateLevels[date]) - 300))
    
    currentOppPlayers = currentOppPlayers[order(currentOppPlayers$Date , decreasing = TRUE ),]
    if(nrow(currentOppPlayers) > 100){
      currentOppPlayers = currentOppPlayers[0:100,]
    }
    
    
    temp$OppTeamDRTGPer = mean(currentOppPlayers$DRTGPer)
    temp$OppTeamORTGPer = mean(currentOppPlayers$ORTGPer)
    temp$OppPosDRTPer = mean(currentOppPlayers[currentOppPlayers$Position %in% currentGame$Position,]$DRTGPer)
    
    temp$DKP = currentGame$DKP[1]
    temp$TotalPoints = currentGame$TotalPoints[1]
    
    OffensiveStatsNew = rbind(temp, OffensiveStatsNew)
  }
  ## Iterate over date
  
}

OffensiveStatsNew[is.na(OffensiveStatsNew)] = 0
OffensiveStatsNew[is.null(OffensiveStatsNew)] = 0

OffensiveStatsNew$X = 0
DefensiveStatsNew$X = 0


DefensiveStats = rbind(DefensiveStatsNew, DefensiveStats)
OffensiveStats = rbind(OffensiveStatsNew, OffensiveStats)


DefensiveStats[is.na(DefensiveStats)] = 0
DefensiveStats[is.null(DefensiveStats)] = 0

OffensiveStats[is.na(OffensiveStats)] = 0
OffensiveStats[is.null(OffensiveStats)] = 0

###### Today's games ####################
###### Today's games ########################## Today's games ####################
###### Today's games ####################
###### Today's games ####################
TodaysDate = Sys.Date()
DefensiveStatsToday = DefensiveStats[0,]
PositionsAll = unique(NBAAllData$Position)
Teams = c(unique(TodaysGames$Team), unique(TodaysGames$Opp))


### Get Defensive stats for each team
for (eachTeam in Teams) {
  # Iterate over each team
  subsetTeamData = subset(NBAAllData, NBAAllData$Team == eachTeam)  
  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  
  #############################
  ### Position######
  ## Iterate over date
    
  for (pos in as.factor(PositionsAll) ){
      # Iterate over each date
      temp = DefensiveStats[1,]
      ## Make sure do not include this date but eveytyhing before.
      subsetTeamData = subset(NBAAllData, NBAAllData$Team == eachTeam 
                              & as.Date(NBAAllData$Date) < TodaysDate &
                                as.Date(NBAAllData$Date) > (TodaysDate - 300) &
                                as.character(NBAAllData$Position) == pos )
      subsetTeamData = subsetTeamData[order(subsetTeamData$Date , decreasing = TRUE ),]

    
      currentGame = subset(TodaysPlayers, TodaysPlayers$Team == eachTeam & TodaysPlayers$Position == pos)
      subsetTeamData = subsetTeamData[subsetTeamData$PlayerName %in% currentGame$PlayerName,] 
      if(nrow(subsetTeamData) > 50){
        subsetTeamData = subsetTeamData[0:50,]
      }
            
      if(nrow(subsetTeamData) == 0){
        next;
      }
      
      temp$Date = TodaysDate
      temp$Tm = eachTeam
      temp$Pos = pos
      
      #### How does team perform in this position historically
      for (column in 4:31){
        print(colnames(temp)[column])
        temp[, colnames(temp)[column]]  = mean(subsetTeamData[, colnames(temp)[column]])
      }
      
      if (eachTeam %in% TodaysGames$Team){
        Opponent = TodaysGames[TodaysGames$Team == eachTeam,]$Opp
      }else{
        Opponent = TodaysGames[TodaysGames$Opp == eachTeam,]$Team
      }
      
      ### Get Opposition Players in the game
      OppPositionPlayers = unique(subset(NBAAllData, NBAAllData$Team == Opponent
                                         & as.Date(NBAAllData$Date) == as.Date(DateLevels[date])
                                         & as.character(NBAAllData$Position) == pos)$PlayerName)
      
      ### Get Opposition Players and their dates to find all games these players particiated in
      OppositionTeams = unique(subset(NBAAllData, NBAAllData$PlayerName %in% OppPositionPlayers)$Opp)
      OppositionDates = unique(subset(NBAAllData, NBAAllData$PlayerName %in% OppPositionPlayers)$Date)
      
      ## Make sure do not include this date but eveytyhing before.
      subsetOppData = subset(NBAAllData, NBAAllData$Team %in% unique(OppositionTeams) 
                             & as.Date(NBAAllData$Date) < TodaysDate
                             & as.Date(NBAAllData$Date) %in% (as.Date(OppositionDates))
                             & as.character(NBAAllData$Position) == pos)
      subsetOppData = subsetOppData[order(subsetOppData$Date , decreasing = TRUE ),]
      if(nrow(subsetOppData) > 50){
        subsetOppData = subsetOppData[0:50,]
      }
      
      #### How many points have been allowed
      for (column in 31:length(colnames(temp)) ){
        #print(colnames(temp)[column])
        col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
        
        temp[, colnames(temp)[column]]  = mean(subsetOppData[, col])
      }
      temp$Date = TodaysDate
      DefensiveStatsToday = rbind(temp, DefensiveStatsToday)
    }
  
}
DefensiveStatsToday[is.na(DefensiveStatsToday)] = 0
DefensiveStatsToday[is.null(DefensiveStatsToday)] = 0
######### Offensive Stats

allPlayers = unique(TodaysPlayers$PlayerName)
OffensiveStatsToday = data.frame(matrix(ncol=38))
colnames(OffensiveStatsToday) = c("PlayerName", "Tm", "Pos" , "Date", "Opp",  "TotalPoints","DKP",
                             "Home","MP",
                             "FG","FGA","ThreeP","ThreePA","FT","FTA","ORB","DRB",
                             "TRB","AST","STL","BLK","TOV","PF","TSPer","eFGPer","ORBPer",
                             "DRBPer","TRBPer","ASTPer","STLPer","BLKPer","TOVPer","USGPer","ORTGPer","DRTGPer",
                             "OppPosDRTPer", "OppTeamDRTGPer", "OppTeamORTGPer")

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(NBAAllData, NBAAllData$PlayerName == player)  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  # Iterate over each date
  temp = OffensiveStatsToday[1,]
  subsetPlayerData = subset(NBAAllData, NBAAllData$PlayerName == player 
                              & as.Date(NBAAllData$Date) < TodaysDate
                              & as.Date(NBAAllData$Date) > (TodaysDate - 300)
    )  
  subsetPlayerData = subsetPlayerData[order(subsetPlayerData$Date , decreasing = TRUE ),]
  if(nrow(subsetPlayerData) > 50){
      subsetPlayerData = subsetPlayerData[0:50,]
  }
  
  CurrenTeam = TodaysPlayers[TodaysPlayers == player,]$Team
  if (CurrenTeam %in% TodaysGames$Team){
    Opponent = TodaysGames[TodaysGames$Team == CurrenTeam,]$Opp
  }else{
    Opponent = TodaysGames[TodaysGames$Opp == CurrenTeam,]$Team
  }
  
  
    
  temp$Date = TodaysDate
  temp$PlayerName = player
  temp$Pos = as.character(subsetPlayerData$Position[1])
  temp$Tm = CurrenTeam
  temp$Opp = Opponent 
  temp$MP = mean(as.numeric(subsetPlayerData$MP))/60
  if (CurrenTeam %in% TodaysGames$Team){
      temp$Home = 0
  }
    else{
      temp$Home = 1
  }
    
    #### How good the player is last 30 days
    for (column in 10:(length(colnames(temp)) - 3) ){
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    ### Opposing Team stats
    currentOppPlayers = unique(subset(TodaysPlayers, TodaysPlayers$Team == Opponent)$PlayerName) 
    
    currentOppPlayers = subset(NBAAllData, NBAAllData$PlayerName %in% currentOppPlayers 
                               & as.Date(NBAAllData$Date) < TodaysDate
                               & as.Date(NBAAllData$Date) > (TodaysDate - 300))
    
    currentOppPlayers = currentOppPlayers[order(currentOppPlayers$Date , decreasing = TRUE ),]
    if(nrow(currentOppPlayers) > 100){
      currentOppPlayers = currentOppPlayers[0:100,]
    }
    
    
    temp$OppTeamDRTGPer = mean(currentOppPlayers$DRTGPer)
    temp$OppTeamORTGPer = mean(currentOppPlayers$ORTGPer)
    temp$OppPosDRTPer = mean(currentOppPlayers[currentOppPlayers$Position %in%  TodaysPlayers[TodaysPlayers == player,]$Position,]$DRTGPer)
    
    temp$DKP = 0
    temp$TotalPoints = 0
    
    OffensiveStatsToday = rbind(temp, OffensiveStatsToday)
}

OffensiveStatsToday = OffensiveStatsToday[!is.na(OffensiveStatsToday$Date),]
DefensiveStatsToday = DefensiveStatsToday[!is.na(DefensiveStatsToday$Date),]

OffensiveStats = OffensiveStats[!OffensiveStats$Date == 0,]
DefensiveStats = DefensiveStats[!DefensiveStats$Date == 0,]

OffensiveStatsToday[is.na(OffensiveStatsToday)] = 0
OffensiveStatsToday[is.null(OffensiveStatsToday)] = 0
OffensiveStatsToday$X  = 0

OffensiveStatsToday$Date = as.Date(OffensiveStatsToday$Date)
OffensiveStats$Date = as.Date(OffensiveStats$Date)

OffensiveStats = rbind(OffensiveStatsToday , OffensiveStats)
DefensiveStats = rbind(DefensiveStatsToday , DefensiveStats)


################## Prediction

################## Results ###############################
CombinedStats = merge(x = OffensiveStats, y = DefensiveStats, by.x = c("Date", "Pos", "Tm"), 
                      by.y = c("Date", "Pos", "Tm") )

write.csv(CombinedStats, file = "CombinedStats.csv")

DateCheck = Sys.Date()
allPlayers = unique(CombinedStats$PlayerName)

Results = data.frame( RFPred = numeric(), player = factor(), position = factor(), salary = numeric(), 
                      date = factor(),
                      ActualMP = numeric(), MP = numeric(), team = factor(), pointsScored = numeric() , 
                      assists = numeric(),
                      rebound = numeric(), pointsAllowedAgainstPosition = numeric(), 
                      playerList = factor(), TeamScore = numeric(), Actual = numeric(),
                      simpleProjection = numeric(), Opp = numeric())

allPlayers = subset(CombinedStats, as.Date(CombinedStats$Date) == DateCheck)$PlayerName

##############################################################
################## NBA Results ###############################
for (player in allPlayers){
  print(player)
  Data_Cleaned_Test = subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck) 
                             & CombinedStats$PlayerName == as.character(player) )
  
  Data_Cleaned_Train = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                              & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 300)
                              & CombinedStats$PlayerName == as.character(player) )
  
  Actual = subset(NBAAllData, as.Date(NBAAllData$Date) == as.Date(DateCheck) 
                  & NBAAllData$PlayerName == as.character(player) )
  
  Actual = Actual[1,]
  Data_Cleaned_Train[is.na(Data_Cleaned_Train)] = 0
  Data_Cleaned_Test[is.na(Data_Cleaned_Test)] = 0
  
  if (nrow(Data_Cleaned_Train) == 0 | nrow(Data_Cleaned_Test) == 0){
    next;
  }
  
  rf = randomForest(Data_Cleaned_Train[,c("FG.x","ThreeP.x","FT.x","TRB.x","STL.x","TOV.x","PF.x",
                                          "TSPer.x","ORBPer.x","TRBPer.x","ASTPer.x",
                                          "STLPer.x","BLKPer.x","TOVPer.x","USGPer.x","ORTGPer.x","DRTGPer.x",
                                          "ThreeP.y","FT.y","AST.y","STL.y",
                                          "TOV.y","PF.y","PTS", "TRBPer.y","STLPer.y","BLKPer.y","TOVPer.y",
                                          "USGPer.y","ORTGPer.y","DRTGPer.y","FGAOpp","ThreePAOpp","FTAOpp",
                                          "TRBOpp","ASTOpp","STLOpp","TOVOpp" )], 
                    y = Data_Cleaned_Train[,c("DKP")], ntree=50 ,type='regression')
  
  RFPred = predict( rf,  Data_Cleaned_Test[,c("FG.x","ThreeP.x","FT.x","TRB.x","STL.x","TOV.x","PF.x",
                                              "TSPer.x","ORBPer.x","TRBPer.x","ASTPer.x",
                                              "STLPer.x","BLKPer.x","TOVPer.x","USGPer.x","ORTGPer.x","DRTGPer.x",
                                              "ThreeP.y","FT.y","AST.y","STL.y",
                                              "TOV.y","PF.y","PTS","TRBPer.y","STLPer.y","BLKPer.y","TOVPer.y",
                                              "USGPer.y","ORTGPer.y","DRTGPer.y","FGAOpp","ThreePAOpp","FTAOpp",
                                              "TRBOpp","ASTOpp","STLOpp","TOVOpp")] ,type = c("response") )
  
  rfTP = randomForest(Data_Cleaned_Train[,c("FG.x","ThreeP.x","FT.x","TRB.x","STL.x","TOV.x","PF.x",
                                            "TSPer.x","ORBPer.x","TRBPer.x","ASTPer.x",
                                            "STLPer.x","BLKPer.x","TOVPer.x","USGPer.x","ORTGPer.x","DRTGPer.x",
                                            "ThreeP.y","FT.y","AST.y","STL.y",
                                            "TOV.y","PF.y","PTS", "TRBPer.y","STLPer.y","BLKPer.y","TOVPer.y",
                                            "USGPer.y","ORTGPer.y","DRTGPer.y","FGAOpp","ThreePAOpp","FTAOpp",
                                            "TRBOpp","ASTOpp","STLOpp","TOVOpp" )], 
                      y = Data_Cleaned_Train[,c("TotalPoints")], ntree=50 ,type='regression')
  
  RFPredTP = predict( rfTP,  Data_Cleaned_Test[,c("FG.x","ThreeP.x","FT.x","TRB.x","STL.x","TOV.x","PF.x",
                                                  "TSPer.x","ORBPer.x","TRBPer.x","ASTPer.x",
                                                  "STLPer.x","BLKPer.x","TOVPer.x","USGPer.x","ORTGPer.x","DRTGPer.x",
                                                  "ThreeP.y","FT.y","AST.y","STL.y",
                                                  "TOV.y","PF.y","PTS","TRBPer.y","STLPer.y","BLKPer.y","TOVPer.y",
                                                  "USGPer.y","ORTGPer.y","DRTGPer.y","FGAOpp","ThreePAOpp","FTAOpp",
                                                  "TRBOpp","ASTOpp","STLOpp","TOVOpp")] ,type = c("response") )
  
  
  Prediction2 = as.data.frame(RFPred)
  Prediction2["player"] = player
  Prediction2["position"] = Data_Cleaned_Test$PlayerPosition
  Prediction2["salary"] = Prediction2$RFPred * 1000/5 
  Prediction2["MP"] = Data_Cleaned_Test$MP
  Prediction2["ActualMP"] = Actual$MP.x
  Prediction2["Team"] = Data_Cleaned_Test$Tm
  Prediction2["pointsScored"] = as.data.frame(RFPredTP)[1]
  Prediction2["assists"] = Data_Cleaned_Test$AST.x*1.25 + (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x)*2
  Prediction2["rebound"] = Data_Cleaned_Test$TRB.x*1.5
  Prediction2["TeamScore"] = 0
  Prediction2$Actual = Actual$DKP
  Prediction2["Opp"] = Data_Cleaned_Test$Opp
  Prediction2["date"] = as.Date(DateCheck)
  
  # Get preivous teams against this position ( last 20 days )
  previousTeams = subset(NBAAllData, NBAAllData$Opp.x == as.character(Data_Cleaned_Test$Opp) 
                         & as.Date(NBAAllData$Date) > (as.Date(DateCheck) - 20) & as.Date(NBAAllData$Date) < (as.Date(DateCheck))
                         & NBAAllData$Position == Data_Cleaned_Test$PlayerPosition
                         & NBAAllData$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) - 1)
                         & NBAAllData$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) + 1))
  i = 0
  
  while(nrow(previousTeams) < 4){
    i = i + 1
    # Get preivous teams against this position ( last 20 days )
    previousTeams = subset(NBAAllData, NBAAllData$Opp.x == as.character(Data_Cleaned_Test$Opp) 
                           & as.Date(NBAAllData$Date) > (as.Date(DateCheck) - 20)
                           & as.Date(NBAAllData$Date) < (as.Date(DateCheck))
                           & NBAAllData$Position == Data_Cleaned_Test$PlayerPosition
                           & NBAAllData$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) - i*0.5)
                           & NBAAllData$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x)+ i*0.5)
    )
    if (i > 10){
      break
    }
  }
  
  dataTM = ""
  
  if (nrow(previousTeams) > 0){
    for (jk in 1:nrow(previousTeams)) {
      datejk = previousTeams$Date[jk]
      tm = previousTeams$Tm[jk]
      previousTeamData = subset(NBAAllData, 
                                as.Date(NBAAllData$Date) == as.Date(datejk)
                                & NBAAllData$Tm == tm
                                & NBAAllData$PTS > previousTeams$PTS[jk] )
      dataTM = paste(previousTeamData$PlayerName, '-', previousTeamData$PTS, collapse = '|H|')
      previousTeams$PlayerPosition[jk] = dataTM
      dataTM = ""
    }
    
  }
  
  ####### Previous teams
  if (nrow(previousTeams) > 0){
    Prediction2["playerList"] = paste('=',previousTeams$PlayerName,'-' , previousTeams$PTS, collapse = '||||||')
    Prediction2["pointsAllowedAgainstPosition"] = mean(previousTeams$PTS)  
  }
  else{
    Prediction2["playerList"] = 0
    Prediction2["pointsAllowedAgainstPosition"] = 0
  }
  
  Prediction2["simpleProjection"] = Prediction2$pointsAllowedAgainstPosition * 1 + Data_Cleaned_Test$ThreeP.x * .5 + Data_Cleaned_Test$AST.x * 1.25 +
    Data_Cleaned_Test$TRB.x * 1.5 + (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x) * 2 - 3
  
  Results = rbind(Results, Prediction2)
}

dbWriteTable(con, name = "NBA_DK_Prediction", value = Results, row.names = FALSE, append = TRUE)  





