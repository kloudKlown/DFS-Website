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
source('NHL_GetDBData.R')

NHLTableData = NHLTableData[,c("PlayerName","PlayerPosition","GID","GameDate","G","Age",
                               "Team","HW","Opp","WinLoss","Goals","Assists",
                               "Points","PlusMinus","Penalties","EGoals","PPGoals","SHGoals",
                               "GWGoals","EVAssits","PPAssits","SHAssits" ,"ShotsOnGoal","ShootingPer",
                               "Shits","MP","Hits","Blocks","FaceOffWins","FaceOffLoss", "FaceOffPer")]
NHLTableData = subset(NHLTableData, as.Date(NHLTableData$GameDate) > as.Date("2017-10-01") )


NHLGoalieData = NHLGoalieData[,c("PlayerName","PlayerPosition","GID","GameDate","G","Age",
                               "Team","HW","Opp","WinLoss","GoalsAgainst",
                               "ShotsAgainst","Saves","SavePercentage","ShoutOuts","Penalties","MP")]




######################################################
############### Team Defensive stats ######################
######################################################
DefensiveStatsNHL = data.frame(matrix(ncol = 30))
colnames(DefensiveStatsNHL) = c("Team","PlayerPosition","GameDate","Goals","Assists",
                                "Points","PlusMinus","Penalties","EGoals","PPGoals","SHGoals",
                                "GWGoals","EVAssits","PPAssits","SHAssits" ,"ShotsOnGoal","ShootingPer",
                                "Shits","MP","Hits","Blocks","FaceOffWins","FaceOffLoss", "FaceOffPer",
                                "GoalsOpp","AssistsOpp","EVAssitsOpp","ShotsOnGoalOpp", "HitsOpp","BlocksOpp")

DefensiveStatsNHL[is.na(DefensiveStatsNHL)] = 0
PositionsAll = unique( NHLTableData$PlayerPosition )
Teams = unique(NHLTableData$Team)

### Get Defensive stats for each team
for (eachTeam in Teams) {
  # Iterate over each team
  subsetTeamData = subset(NHLTableData, NHLTableData$Team == eachTeam)  
  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  DateLevels = as.factor(unique(subsetTeamData[order(subsetTeamData$GameDate , decreasing = FALSE ),]$GameDate))  
  
  #############################
  ### Position######
  ## Iterate over date
  for (date in 1:length(DateLevels)){
    print(paste("Team = ", eachTeam, " level " ,length(DateLevels)/date))
    
    for (pos in as.factor(PositionsAll) ){
      # Iterate over each date
      temp = DefensiveStatsNHL[1,]
      ## Make sure do not include this date but eveytyhing before.
      subsetTeamData = subset(NHLTableData, NHLTableData$Team == eachTeam 
                                & as.Date(NHLTableData$GameDate) < as.Date(DateLevels[date]) &
                                  as.Date(NHLTableData$GameDate) > (as.Date(DateLevels[date]) - 300)&
                                as.character(NHLTableData$PlayerPosition) == pos)
      
      subsetTeamData = subsetTeamData[order(subsetTeamData$GameDate , decreasing = TRUE ),]
        
      currentGame = subset(NHLTableData, NHLTableData$Team == eachTeam 
                             & as.Date(NHLTableData$GameDate) == as.Date(DateLevels[date])&
                             as.character(NHLTableData$PlayerPosition) == pos)
      
      subsetTeamData = subsetTeamData[subsetTeamData$PlayerName %in% currentGame$PlayerName,] 
        
      if(nrow(subsetTeamData) > 50){
          subsetTeamData = subsetTeamData[0:50,]
      }
        
        
      if(nrow(subsetTeamData) == 0){
          next;
      }
        
      temp$GameDate = DateLevels[date]
      temp$PlayerPosition = pos
      temp$Team = eachTeam
        
      #### How does team perform in this position historically
      for (column in 4:24){
          print(colnames(temp)[column])
          temp[, colnames(temp)[column]]  = mean(subsetTeamData[, colnames(temp)[column]])
      }
      
      ### Get Opposition Players in the game
      OppPositionPlayers = unique(subset(NHLTableData, NHLTableData$Team == currentGame$Opp[1]
                                           & as.Date(NHLTableData$GameDate) == as.Date(DateLevels[date])&
                                           as.character(NHLTableData$PlayerPosition) == pos)$PlayerName)
        
      ### Get Opposition Players and their dates to find all games these players particiated in
      OppositionTeams = unique(subset(NHLTableData, NHLTableData$PlayerName %in% OppPositionPlayers
                                      & as.Date(NHLTableData$GameDate) < as.Date(DateLevels[date]))$Opp)
      
      OppositionDates = unique(subset(NHLTableData, NHLTableData$PlayerName %in% OppPositionPlayers
                                      & as.Date(NHLTableData$GameDate) < as.Date(DateLevels[date]))$GameDate)
      ## Make sure do not include this date but eveytyhing before.
      subsetOppData = subset(NHLTableData, NHLTableData$Team %in% unique(OppositionTeams) 
                               & as.Date(NHLTableData$GameDate) < as.Date(DateLevels[date]) 
                               & as.Date(NHLTableData$GameDate) %in% (as.Date(OppositionDates)) &
                               as.character(NHLTableData$PlayerPosition) == pos)
      
      subsetOppData = subsetOppData[order(subsetOppData$GameDate , decreasing = TRUE ),]
      if(nrow(subsetOppData) > 50){
          subsetOppData = subsetOppData[0:50,]
      }
        
      #### How many points have been allowed
      for (column in 24:length(colnames(temp)) ){
        #print(colnames(temp)[column])
        col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
          
        temp[, colnames(temp)[column]]  = mean(subsetOppData[, col])
      }
        
      DefensiveStatsNHL = rbind(temp, DefensiveStatsNHL)
    }
    
  }
}


write.csv(DefensiveStatsNHL, file = "DefensiveStatsNHL_All.csv")

######################################################
######### Offensive Stats
OffensiveStatsNHL = data.frame(matrix(ncol=35))
colnames(OffensiveStatsNHL) = c("PlayerName", "Team", "PlayerPosition" , "GameDate", "Opp", "MP","HW",
                                "TotalGoals","DKP", "Goals","Assists","Points","PlusMinus","Penalties","EGoals","PPGoals","SHGoals",
                                "GWGoals","EVAssits","PPAssits","SHAssits" ,"ShotsOnGoal","ShootingPer",
                                "Shits","Hits","Blocks","FaceOffWins","FaceOffLoss", "FaceOffPer",
                                "GoalsOpp","FaceOffPerOpp","EVAssitsOpp","ShotsOnGoalOpp", "HitsOpp","BlocksOpp"
                                )

NHLTableData$TotalGoals = NHLTableData$Goals
NHLTableData$DKP = NHLTableData$EGoals * 8.5 + NHLTableData$EVAssits * 5 + NHLTableData$ShotsOnGoal * 1.5 + 
  NHLTableData$Blocks * 1.5 + NHLTableData$SHGoals * 2 + NHLTableData$SHAssits * 2

allPlayers = unique(NHLTableData$PlayerName)

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(NHLTableData, NHLTableData$PlayerName == player)  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = FALSE ),]$GameDate))  
  # Add current Date
  # DateLevels = factor(c(levels(DateLevels),substring(Sys.time(),0,10)))
  print(player)
  ## Iterate over date
  for (date in 2:length(DateLevels)){
    # Iterate over each date
    temp = OffensiveStatsNHL[1,]
    subsetPlayerData = subset(NHLTableData, NHLTableData$PlayerName == player 
                              & as.Date(NHLTableData$GameDate) < as.Date(DateLevels[date]) 
                              & as.Date(NHLTableData$GameDate) > (as.Date(DateLevels[date]) - 30)
    )  
    subsetPlayerData = subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = TRUE ),]
    if(nrow(subsetPlayerData) > 10){
      subsetPlayerData = subsetPlayerData[0:10,]
    }
    
    currentGame = subset(NHLTableData, NHLTableData$PlayerName == player 
                         & as.Date(NHLTableData$GameDate) == as.Date(DateLevels[date])) 
    
    if (nrow(currentGame) == 0 ){
      next
    }
    
    temp$GameDate = DateLevels[date]
    temp$PlayerName = player
    temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
    temp$Team = as.character(subsetPlayerData$Team[1])
    temp$Opp = as.character(currentGame$Opp[1])     
    temp$MP = mean(as.numeric(subsetPlayerData$MP))/60
    if (currentGame$HW == '@' | currentGame$HW == 'N'){
      temp$HW = 0
    }
    else{
      temp$HW = 1
    }
    
    #### How good the player is last 30 days
    for (column in 8:(length(colnames(temp)) - 6) ){
      print(colnames(temp)[column])
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    ### Opposing Team stats
    currentOppPlayers = unique(subset(NHLTableData, NHLTableData$Team == currentGame$Opp 
                                      & as.Date(NHLTableData$GameDate) == as.Date(DateLevels[date]))$PlayerName) 
    
    currentOppPlayers = subset(NHLTableData, NHLTableData$PlayerName %in% currentOppPlayers 
                               & as.Date(NHLTableData$GameDate) < as.Date(DateLevels[date])
                               & as.Date(NHLTableData$GameDate) > (as.Date(DateLevels[date]) - 15))
    
    currentOppPlayers = currentOppPlayers[order(currentOppPlayers$GameDate , decreasing = TRUE ),]
    if(nrow(currentOppPlayers) > 100){
      currentOppPlayers = currentOppPlayers[0:100,]
    }
    
    temp$GoalsOpp = mean(currentOppPlayers$Goals)
    temp$EVAssitsOpp = mean(currentOppPlayers$EVAssits)
    temp$ShotsOnGoalOpp = mean(currentOppPlayers$ShotsOnGoal)
    temp$BlocksOpp = mean(currentOppPlayers$Blocks)
    temp$HitsOpp = mean(currentOppPlayers$Hits)
    temp$FaceOffPerOpp = mean(currentOppPlayers$FaceOffPer)
    temp$DKP = currentGame$DKP[1]
    temp$TotalGoals = currentGame$TotalGoals[1]
    
    OffensiveStatsNHL = rbind(temp, OffensiveStatsNHL)
  }
  ## Iterate over date
  
}

OffensiveStatsNHL[is.na(OffensiveStatsNHL)] = 0
OffensiveStatsNHL[is.null(OffensiveStatsNHL)] = 0
write.csv(OffensiveStatsNHL, file = "OffensiveStatsNHL_All.csv")




############################################
############ Goalie Stats ##################
############################################
GoalieStatsNHL = data.frame(matrix(ncol=19))
colnames(GoalieStatsNHL) = c("PlayerName", "Team", "PlayerPosition" , "GameDate", "Opp", "MP","HW","DKP",
                             "GoalsAgainst","ShotsAgainst","Saves","SavePercentage","ShoutOuts","Penalties",
                             "Hits","Blocks","ShotsOpp", "HitsOpp", "GoalsOpp")

NHLGoalieData$DKP = NHLGoalieData$Saves* 0.7 - NHLGoalieData$GoalsAgainst * 3.5

allPlayers = unique(NHLGoalieData$PlayerName)

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(NHLGoalieData, NHLGoalieData$PlayerName == player)  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = FALSE ),]$GameDate))  
  # Add current Date
  # DateLevels = factor(c(levels(DateLevels),substring(Sys.time(),0,10)))
  print(player)
  ## Iterate over date
  for (date in 2:length(DateLevels)){
    # Iterate over each date
    temp = GoalieStatsNHL[1,]
    subsetPlayerData = subset(NHLGoalieData, NHLGoalieData$PlayerName == player 
                              & as.Date(NHLGoalieData$GameDate) < as.Date(DateLevels[date]) 
                              & as.Date(NHLGoalieData$GameDate) > (as.Date(DateLevels[date]) - 30)
    )  
    subsetPlayerData = subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = TRUE ),]
    
    currentGame = subset(NHLGoalieData, NHLGoalieData$PlayerName == player 
                         & as.Date(NHLGoalieData$GameDate) == as.Date(DateLevels[date])) 
    
    if (nrow(currentGame) == 0 ){
      next
    }
    
    ### Current Team Stats
    currentPlayers = unique(subset(NHLTableData, NHLTableData$Team == currentGame$Team 
                                      & as.Date(NHLTableData$GameDate) == as.Date(DateLevels[date]))$PlayerName) 
    
    currentPlayers = subset(NHLTableData, NHLTableData$PlayerName %in% currentPlayers 
                               & as.Date(NHLTableData$GameDate) < as.Date(DateLevels[date])
                               & as.Date(NHLTableData$GameDate) > (as.Date(DateLevels[date]) - 30))
    
    currentPlayers = currentPlayers[order(currentPlayers$GameDate , decreasing = TRUE ),]
    
    if(nrow(currentOppPlayers) > 100){
      currentOppPlayers = currentOppPlayers[0:100,]
    }
    if (nrow(currentPlayers) == 0 ){
      next
    }
    
    currentPlayers = aggregate(currentPlayers[,11:30], by = list(currentPlayers$GameDate), FUN = sum, na.rm=TRUE)
   
    
    temp$GameDate = DateLevels[date]
    temp$PlayerName = player
    temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
    temp$Team = as.character(subsetPlayerData$Team[1])
    temp$Opp = as.character(currentGame$Opp[1])     
    temp$MP = mean(as.numeric(subsetPlayerData$MP))/60
    if (currentGame$HW == '@' | currentGame$HW == 'N'){
      temp$HW = 0
    }
    else{
      temp$HW = 1
    }
    
    #### How good the player is last 30 days
    for (column in 9:(length(colnames(temp)) - 5) ){
      print(colnames(temp)[column])
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    temp$Hits = mean(currentPlayers$Hits)
    temp$Blocks = mean(currentPlayers$Blocks)
    temp$DKP = currentGame$DKP[1]
    
    ### Opposing Team stats
    currentOppPlayers = unique(subset(NHLTableData, NHLTableData$Team == currentGame$Opp 
                                      & as.Date(NHLTableData$GameDate) == as.Date(DateLevels[date]))$PlayerName) 
    
    currentOppPlayers = subset(NHLTableData, NHLTableData$PlayerName %in% currentOppPlayers 
                               & as.Date(NHLTableData$GameDate) < as.Date(DateLevels[date])
                               & as.Date(NHLTableData$GameDate) > (as.Date(DateLevels[date]) - 30))
    
    currentOppPlayers = currentOppPlayers[order(currentOppPlayers$GameDate , decreasing = TRUE ),]
    if(nrow(currentOppPlayers) > 100){
      currentOppPlayers = currentOppPlayers[0:100,]
    }
    if (nrow(currentOppPlayers) == 0 ){
      next
    }
    
    currentOppPlayers = aggregate(currentOppPlayers[,11:30], by = list(currentOppPlayers$GameDate), FUN = sum, na.rm=TRUE)
    
    temp$ShotsOpp = mean(currentOppPlayers$Shots)
    temp$HitsOpp = mean(currentOppPlayers$Hits)
    temp$GoalsOpp = mean(currentOppPlayers$Goals)
    
    GoalieStatsNHL = rbind(temp, GoalieStatsNHL)
  }
  ## Iterate over date
  
}
GoalieStatsNHL[is.na(GoalieStatsNHL)] = 0
GoalieStatsNHL[is.null(GoalieStatsNHL)] = 0
write.csv(GoalieStatsNHL, file = "GoalieStatsNHL_All.csv")

