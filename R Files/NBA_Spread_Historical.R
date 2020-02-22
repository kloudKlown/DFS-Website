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
setwd("D:/DFS Website/DFS/R Files")
source('NBA_getDBData.R')

NBATableData = NBATableData[,c("PlayerName","Position","Date","Team","blank","Opp","blank2","MP",
                               "FG","FGA","FGper","ThreeP","ThreePA","ThreePper",
                               "FT","FTA","FTper","ORB","DRB","TRB","AST","STL",
                               "BLK","TOV","PF","PTS","GmSc",
                               "TSPer","eFGPer","ORBPer","DRBPer","TRBPer","ASTPer",
                               "STLPer","BLKPer","TOVPer","USGPer","ORTGPer","DRTGPer")]


NBAAllData = NBATableData

NBAAllData$Date = as.Date(NBAAllData$Date)
######################################################
############### Team Defensive stats ######################
######################################################
DefensiveStats = data.frame(matrix(ncol = 38))
colnames(DefensiveStats) = c("Tm","Pos" ,"Date","FG","FGA","ThreeP","ThreePA",
                             "FT","FTA","ORB","DRB","TRB","AST",
                             "STL","BLK","TOV","PF", "PTS", "TSPer","eFGPer","ORBPer",
                             "DRBPer","TRBPer","ASTPer","STLPer","BLKPer","TOVPer","USGPer","ORTGPer","DRTGPer",
                             "FGAOpp", "ThreePAOpp", "FTAOpp", "TRBOpp","ASTOpp","STLOpp","BLKOpp","TOVOpp")

DefensiveStats[is.na(DefensiveStats)] = 0

PositionsAll = c("C", "PG", "SG", "SF", "PF")
Teams = unique(NBAAllData$Team)

### Get Defensive stats for each team
for (eachTeam in Teams) {
  # Iterate over each team
  subsetTeamData = subset(NBAAllData, NBAAllData$Team == eachTeam)  
  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  DateLevels = as.factor(unique(subsetTeamData[order(subsetTeamData$Date , decreasing = FALSE ),]$Date))  
  
  #############################
  ### Position######
  ## Iterate over date
  for (date in 1:length(DateLevels)){
    print(paste("Team = ", eachTeam, " level " ,length(DateLevels)/date))
    
    for (pos in as.factor(PositionsAll) ){
      # Iterate over each date
      temp = DefensiveStats[1,]
      ## Make sure do not include this date but eveytyhing before.
      subsetTeamData = subset(NBAAllData, NBAAllData$Team == eachTeam 
                              & as.Date(NBAAllData$Date) < as.Date(DateLevels[date]) &
                                as.Date(NBAAllData$Date) > (as.Date(DateLevels[date]) - 300) &
                                as.character(NBAAllData$Position) == pos )
      subsetTeamData = subsetTeamData[order(subsetTeamData$Date , decreasing = TRUE ),]
      
      currentGame = subset(NBAAllData, NBAAllData$Team == eachTeam 
                           & as.Date(NBAAllData$Date) == as.Date(DateLevels[date]))
      # subsetTeamData = subsetTeamData[subsetTeamData$PlayerName %in% currentGame$PlayerName,] 
      
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
      for (column in 4:30){
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
      for (column in 30:length(colnames(temp)) ){
        #print(colnames(temp)[column])
        col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
        
        temp[, colnames(temp)[column]]  = mean(subsetOppData[, col])
      }
      
      DefensiveStats = rbind(temp, DefensiveStats)
    }
    
  }
}


write.csv(DefensiveStats, file = "DefensiveStats_All.csv")


######################################################
############### Player stats ######################
######################################################
######### Offensive Stats
OffensiveStats = data.frame(matrix(ncol=38))
colnames(OffensiveStats) = c("PlayerName", "Tm", "Pos" , "Date", "Opp",  "TotalPoints","DKP",
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
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$Date , decreasing = FALSE ),]$Date))  
  # Add current Date
  # DateLevels = factor(c(levels(DateLevels),substring(Sys.time(),0,10)))
  print(player)
  ## Iterate over date
  for (date in 2:length(DateLevels)){
    # Iterate over each date
    temp = OffensiveStats[1,]
    subsetPlayerData = subset(NBAAllData, NBAAllData$PlayerName == player 
                              & as.Date(NBAAllData$Date) < as.Date(DateLevels[date]) 
                              & as.Date(NBAAllData$Date) > (as.Date(DateLevels[date]) - 300)
    )  
    subsetPlayerData = subsetPlayerData[order(subsetPlayerData$Date , decreasing = TRUE ),]
    if(nrow(subsetPlayerData) > 10){
      subsetPlayerData = subsetPlayerData[0:10,]
    }
    
    currentGame = subset(NBAAllData, NBAAllData$PlayerName == player 
                         & as.Date(NBAAllData$Date) == as.Date(DateLevels[date])) 
    
    if (nrow(currentGame) == 0 ){
      next
    }
    
    temp$Date = DateLevels[date]
    temp$PlayerName = player
    temp$Pos = as.character(subsetPlayerData$Position[1])
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
    
    OffensiveStats = rbind(temp, OffensiveStats)
  }
  ## Iterate over date
  
}

OffensiveStats[is.na(OffensiveStats)] = 0
OffensiveStats[is.null(OffensiveStats)] = 0
write.csv(OffensiveStats, file = "OffensiveStats_All.csv")
OffensiveStats = read.csv('OffensiveStats_All.csv')
DefensiveStats = read.csv('DefensiveStats_All.csv')

#######################################################################
#######################################################################
################## Player Shot Log ####################################

ShotPlayerLogStats = ShotPlayerLog[0,]
allPlayers = unique(ShotPlayerLog$PlayerName)

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(ShotPlayerLog, ShotPlayerLog$PlayerName == player) 
  DefensiveStatsMaxDate = max(as.Date(subset(ShotPlayerLogStats, ShotPlayerLogStats$PlayerName == player)$GameDate ), na.rm =  TRUE)
  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = FALSE ),]$GameDate))
  
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
    temp = ShotPlayerLog[1,]
    subsetPlayerData = subset(ShotPlayerLog, ShotPlayerLog$PlayerName == player 
                              & as.Date(ShotPlayerLog$GameDate) < as.Date(DateLevels[date]) 
                              & as.Date(ShotPlayerLog$GameDate) > (as.Date(DateLevels[date]) - 30)
    )  
    subsetPlayerData = subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = TRUE ),]
    if(nrow(subsetPlayerData) > 4){
      subsetPlayerData = subsetPlayerData[0:4,]
    }
    
    currentGame = subset(ShotPlayerLog, ShotPlayerLog$PlayerName == player 
                         & as.Date(ShotPlayerLog$GameDate) == as.Date(DateLevels[date])) 
    
    if (nrow(currentGame) == 0 ){
      next
    }
    
    temp$GameDate = DateLevels[date]
    temp$PlayerName = player
    
    #### How good the player is last 30 days
    for (column in 3:(length(colnames(temp))) ){
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    ShotPlayerLogStats = rbind(temp, ShotPlayerLogStats)
  }
  ## Iterate over date
  
}

ShotPlayerLogStats[is.na(ShotPlayerLogStats)] = 0
ShotPlayerLogStats[is.null(ShotPlayerLogStats)] = 0

#######################################################################
#######################################################################
################## Team Shot Allowed Log ####################################

ShotTeamLogStats = ShotTeamPlayerLog[0,]
allPlayers = unique(ShotTeamPlayerLog$HomeTeam)

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(ShotTeamPlayerLog, ShotTeamPlayerLog$HomeTeam == player) 
  DefensiveStatsMaxDate = max(as.Date(subset(ShotTeamLogStats, ShotTeamLogStats$HomeTeam == player)$GameDate ), na.rm =  TRUE)
  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = FALSE ),]$GameDate))
  
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
    temp = ShotTeamPlayerLog[1,]
    subsetPlayerData = subset(ShotTeamPlayerLog, ShotTeamPlayerLog$HomeTeam == player 
                              & as.Date(ShotTeamPlayerLog$GameDate) < as.Date(DateLevels[date]) 
                              & as.Date(ShotTeamPlayerLog$GameDate) > (as.Date(DateLevels[date]) - 30)
    )  
    subsetPlayerData = subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = TRUE ),]
    if(nrow(subsetPlayerData) == 0){
      next
    }
    
    if(nrow(subsetPlayerData) > 5){
      subsetPlayerData = subsetPlayerData[0:5,]
    }
    
    subsetPlayerData = aggregate(subsetPlayerData[,3:length(temp)], by = list(subsetPlayerData$HomeTeam, subsetPlayerData$GameDate), FUN = sum, na.rm=TRUE)
    
    currentGame = subset(ShotTeamPlayerLog, ShotTeamPlayerLog$HomeTeam == player &
                           as.Date(ShotTeamPlayerLog$GameDate) == as.Date(DateLevels[date]) ) 
    
    if (nrow(currentGame) == 0 ){
      next
    }
    
    temp$GameDate = DateLevels[date]
    temp$HomeTeam = player
    
    #### How good the player is last 30 days
    for (column in 3:(length(colnames(temp))) ){
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    ShotTeamLogStats = rbind(temp, ShotTeamLogStats)
  }
  ## Iterate over date
  
}

ShotTeamLogStats[is.na(ShotTeamLogStats)] = 0
ShotTeamLogStats[is.null(ShotTeamLogStats)] = 0
##########################################################
##########################################################
## varclus Batters
spearmanP = varclus(as.matrix(CombinedStatsShots[,c("FG.x","ThreeP.x","MP",
                                               "FT.x",
                                               "TRB.x","TOV.x","PF.x",
                                               "TSPer.x","ORBPer.x","TRBPer.x","ASTPer.x",
                                               "STLPer.x","BLKPer.x","TOVPer.x","USGPer.x","ORTGPer.x","DRTGPer.x",
                                               "ThreeP.y","FT.y","AST.y",
                                               "TOV.y","PF.y","PTS","TRBPer.y","STLPer.y","BLKPer.y","TOVPer.y",
                                               "USGPer.y","ORTGPer.y","DRTGPer.y","FGAOpp","ThreePAOpp","FTAOpp",
                                               "TRBOpp","ASTOpp","STLOpp","TOVOpp",
                                               "R3.x.x", "L3.x.x", "C3.x.x", "IP.x.x", "RC3.x.x", "LC3.x.x", "B3.x.x", "L2.x.x", "R2.x.x", "C2.x.x",
                                               "R3.y.x", "L3.y.x", "C3.y.x", "IP.y.x", "RC3.y.x", "LC3.y.x", "B3.y.x", "L2.y.x", "R2.y.x", "C2.y.x",
                                               "R3.x.y", "L3.x.y", "C3.x.y", "IP.x.y", "RC3.x.y", "LC3.x.y", "B3.x.y", "L2.x.y", "R2.x.y", "C2.x.y",
                                               "R3.y.y", "L3.y.y", "C3.y.y", "IP.y.y", "RC3.y.y", "LC3.y.y", "B3.y.y", "L2.y.y", "R2.y.y", "C2.y.y"                                               
                                               )] ), similarity = "spearman")
plot(spearmanP)
abline(h=0.3)

################## Results ###############################

DefensiveStatsShot = merge(x = DefensiveStats, y = ShotTeamLogStats, by.x = c("Date", "Tm"),
                       by.y = c("GameDate", "HomeTeam"), all.x = TRUE)

CombinedStats = merge(x = OffensiveStats, y = DefensiveStatsShot, by.x = c("Date", "Pos", "Tm"), 
                      by.y = c("Date", "Pos", "Tm") )
CombinedStats[is.na(CombinedStats)] = 0
CombinedStats[is.null(CombinedStats)] = 0


CombinedStatsShots = merge(x = CombinedStats, y = ShotPlayerLogStats, by.x = c("Date", "PlayerName"),
                          by.y = c("GameDate", "PlayerName"), all.x = TRUE)

write.csv(CombinedStats, file = "CombinedStats.csv")


allPlayers = unique(CombinedStatsShots$PlayerName)


for (variable in c(3:365)) {
  CombinedStats = merge(x = OffensiveStats, y = DefensiveStats, by.x = c("Date", "Pos", "Tm"), 
                        by.y = c("Date", "Pos", "Tm") )
  
  CombinedStats = merge(x = CombinedStats, y = DefensiveStats, by.x = c("Date", "Pos", "Opp"), 
                        by.y = c("Date", "Pos", "Tm") )
  
  DateCheck =   as.Date("2020-01-30") - variable
  allPlayers = unique(CombinedStats$PlayerName)
  Results = data.frame( RFPred = numeric(), player = factor(), position = factor(), salary = numeric(), 
                        date = factor(),
                        ActualMP = numeric(), MP = numeric(), Team = factor(), pointsScored = numeric() , 
                        assists = numeric(),
                        rebound = numeric(), pointsAllowedAgainstPosition = numeric(), 
                        playerList = factor(), TeamScore = numeric(), Actual = numeric(),
                        simpleProjection = numeric(), Opp = numeric())
  
  allPlayers = unique(subset(CombinedStats, as.Date(CombinedStats$Date) == DateCheck)$PlayerName)
  
  predictionNames = c("FG.x","ThreeP.x","FT.x","TRB.x","STL.x","TOV.x","PF.x",
                      "TSPer.x","ORBPer.x","TRBPer.x","ASTPer.x",
                      "STLPer.x","BLKPer.x","TOVPer.x","USGPer.x","ORTGPer.x","DRTGPer.x",
                      "ThreeP.y","FT.y","AST.y","STL.y",
                      "TOV.y","PF.y","TRBPer.y","STLPer.y","BLKPer.y","TOVPer.y",
                      "USGPer.y","ORTGPer.y","DRTGPer.y","FGAOpp.x","ThreePAOpp.x","FTAOpp.x",
                      "TRBOpp.x","ASTOpp.x","STLOpp.x","TOVOpp.x",
                      "FT","AST","STL","TOV","PF","TRBPer","STLPer","BLKPer","TOVPer",
                      "USGPer","ORTGPer","DRTGPer","FGAOpp.y","ThreePAOpp.y","FTAOpp.y",
                      "TRBOpp.y","ASTOpp.y","STLOpp.y","TOVOpp.y")
  
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
    
    RFCollector = c()
    for (variable in 1:5) {
      rf = randomForest(Data_Cleaned_Train[,predictionNames], 
                        y = Data_Cleaned_Train[,c("DKP")], ntree=50 ,type='regression')
      
      RFPred = predict( rf,  Data_Cleaned_Test[,predictionNames] ,type = c("response") )
      
      RFCollector[variable]  = RFPred
    }
    
    
    rfTP = randomForest(Data_Cleaned_Train[,predictionNames], 
                        y = Data_Cleaned_Train[,c("TotalPoints")], ntree=50 ,type='regression')
    
    RFPredTP = predict( rfTP,  Data_Cleaned_Test[,predictionNames] ,type = c("response") )
    
    Prediction2 = Results[1,]
    Prediction2["RFPred"] = mean(RFCollector)
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
    
    
    Results = rbind(Results, Prediction2)
  }
  dbSendQuery(con, paste("DELETE From NBA_DK_Prediction where [date] = '", DateCheck , "'"))
  dbWriteTable(con, name = "NBA_DK_Prediction", value = Results, row.names = FALSE, append = TRUE)  
  
}
##############################################################
##############################################################

