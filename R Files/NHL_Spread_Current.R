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


library(odbc)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "localhost",
                 Database = "NHL",
                 Trusted_Connection = "True",
                 Port = 1433)


NHLSavantPlayer = dbSendQuery(con, paste("Select * From NHL_Games where GameDate = '", Sys.Date() , "'"))
TodaysGamesNHL = dbFetch(NHLSavantPlayer)
dbClearResult(NHLSavantPlayer)
rm(NHLSavantPlayer)
rm(con)


NHLTableData = NHLTableData[,c("PlayerName","PlayerPosition","GID","GameDate","G","Age",
                               "Team","HW","Opp","WinLoss","Goals","Assists",
                               "Points","PlusMinus","Penalties","EGoals","PPGoals","SHGoals",
                               "GWGoals","EVAssits","PPAssits","SHAssits" ,"ShotsOnGoal","ShootingPer",
                               "Shits","MP","Hits","Blocks","FaceOffWins","FaceOffLoss", "FaceOffPer")]


NHLTableData$TotalGoals = NHLTableData$Goals
NHLTableData$DKP = NHLTableData$EGoals * 8.5 + NHLTableData$EVAssits * 5 + NHLTableData$ShotsOnGoal * 1.5 + 
  NHLTableData$Blocks * 1.5 + NHLTableData$SHGoals * 2 + NHLTableData$SHAssits * 2


OffensiveStatsNHL = read.csv('OffensiveStatsNHL_All.csv')
DefensiveStatsNHL = read.csv('DefensiveStatsNHL_All.csv')
OffensiveStatsNHL = subset(OffensiveStatsNHL, select = -X)
DefensiveStatsNHL = subset(DefensiveStatsNHL, select = -X)




######################################################
############### Team Defensive stats ######################
######################################################
DefensiveStatsNewNHL = DefensiveStatsNHL[0,]
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
  DefensiveStatsMaxDate = max(as.Date(subset(DefensiveStatsNHL, DefensiveStatsNHL$Team == eachTeam)$GameDate ), na.rm =  TRUE)  
  
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
      
      DefensiveStatsNewNHL = rbind(temp, DefensiveStatsNewNHL)
    }
    
  }
}

#################################################################################
######################## Offensive Stats ########################################
OffensiveStatsNewNHL = OffensiveStatsNHL[0,]
PositionsAll = unique( NHLTableData$PlayerPosition )
allPlayers = unique(NHLTableData$PlayerName)


for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(NHLTableData, NHLTableData$PlayerName == player)  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = FALSE ),]$GameDate))  
  DefensiveStatsMaxDate = max(as.Date(subset(OffensiveStatsNHL, OffensiveStatsNHL$PlayerName == player)$GameDate ), na.rm =  TRUE)
  
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
    
    OffensiveStatsNewNHL = rbind(temp, OffensiveStatsNewNHL)
  }
  ## Iterate over date
  
}

OffensiveStatsNewNHL[is.na(OffensiveStatsNewNHL)] = 0
OffensiveStatsNewNHL[is.null(OffensiveStatsNewNHL)] = 0
#########################################################################
######################### Goalie ########################################
GoalieStatsNewNHL = GoalieStatsNHL[0,]
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
  DefensiveStatsMaxDate = max(as.Date(subset(GoalieStatsNHL, GoalieStatsNHL$PlayerName == player)$GameDate ), na.rm =  TRUE)
  
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
    
    GoalieStatsNewNHL = rbind(temp, GoalieStatsNewNHL)
  }
  ## Iterate over date
  
}
GoalieStatsNewNHL[is.na(GoalieStatsNewNHL)] = 0
GoalieStatsNewNHL[is.null(GoalieStatsNewNHL)] = 0




DefensiveStatsNHL = rbind(DefensiveStatsNewNHL, DefensiveStatsNHL)
OffensiveStatsNHL = rbind(OffensiveStatsNewNHL, OffensiveStatsNHL)
GoalieStatsNHL = rbind(GoalieStatsNewNHL, GoalieStatsNHL)

GoalieStatsNHL[is.na(GoalieStatsNHL)] = 0
GoalieStatsNHL[is.null(GoalieStatsNHL)] = 0
DefensiveStatsNHL[is.na(DefensiveStatsNHL)] = 0
DefensiveStatsNHL[is.null(DefensiveStatsNHL)] = 0
OffensiveStatsNHL[is.na(OffensiveStatsNHL)] = 0
OffensiveStatsNHL[is.null(OffensiveStatsNHL)] = 0

write.csv(DefensiveStatsNHL, file = "DefensiveStatsNHL_All.csv")
write.csv(OffensiveStatsNHL, file = "OffensiveStatsNHL_All.csv")
write.csv(GoalieStatsNHL, file = "GoalieStatsNHL_All.csv")
###### Today's games ####################
###### Today's games ########################## Today's games ####################
###### Today's games ####################
###### Today's games ####################
TodaysDate = Sys.Date()
DefensiveStatsNHLToday = DefensiveStatsNHL[0,]
PositionsAll = unique(NHLTableData$PlayerPosition)
Teams = c(unique(TodaysGamesNHL$Team), unique(TodaysGamesNHL$Opp))


### Get Defensive stats for each team
for (eachTeam in Teams) {
  # Iterate over each team
  subsetTeamData = subset(NHLTableData, NHLTableData$Team == eachTeam)  
  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  
  #############################
  ### Position######
  ## Iterate over date
  
  for (pos in as.factor(PositionsAll) ){
    # Iterate over each date
    temp = DefensiveStatsNHL[1,]
    ## Make sure do not include this date but eveytyhing before.
    subsetTeamData = subset(NHLTableData, NHLTableData$Team == eachTeam 
                            & as.Date(NHLTableData$GameDate) < TodaysDate &
                              as.Date(NHLTableData$GameDate) > (TodaysDate - 300) &
                              as.character(NHLTableData$PlayerPosition) == pos )
    subsetTeamData = subsetTeamData[order(subsetTeamData$GameDate , decreasing = TRUE ),]
    
    
    # currentGame = subset(TodaysPlayers, TodaysPlayers$Team == eachTeam & TodaysPlayers$Position == pos)
    # subsetTeamData = subsetTeamData[subsetTeamData$PlayerName %in% currentGame$PlayerName,] 
    if(nrow(subsetTeamData) > 50){
      subsetTeamData = subsetTeamData[0:50,]
    }
    
    if(nrow(subsetTeamData) == 0){
      next;
    }
    
    temp$GameDate = TodaysDate
    temp$Team = eachTeam
    temp$PlayerPosition = pos
    
    #### How does team perform in this position historically
    for (column in 4:24){
      print(colnames(temp)[column])
      temp[, colnames(temp)[column]]  = mean(subsetTeamData[, colnames(temp)[column]])
    }
    
     currentGame = TodaysGamesNHL[TodaysGamesNHL$Team == eachTeam,]
    if(nrow(currentGame) == 0){
      currentGame = TodaysGamesNHL[TodaysGamesNHL$Opp == eachTeam,]  
    }
    
    ### Get Opposition Players in the game
    OppPositionPlayers = unique(subset(NHLTableData, NHLTableData$Team == currentGame$Opp[1] &
                                       as.Date(NHLTableData$GameDate) < TodaysDate &
                                         as.Date(NHLTableData$GameDate) > (TodaysDate - 30) &
                                         as.character(NHLTableData$PlayerPosition) == pos)$PlayerName)
    
    ### Get Opposition Players and their dates to find all games these players particiated in
    OppositionTeams = unique(subset(NHLTableData, NHLTableData$PlayerName %in% OppPositionPlayers)$Opp)
    OppositionDates = unique(subset(NHLTableData, NHLTableData$PlayerName %in% OppPositionPlayers)$GameDate)
    
    ## Make sure do not include this date but eveytyhing before.
    subsetOppData = subset(NHLTableData, NHLTableData$Team  == currentGame$Opp[1]
                           & as.Date(NHLTableData$GameDate) < TodaysDate
                           & NHLTableData$PlayerName %in% OppPositionPlayers
                           & as.character(NHLTableData$PlayerPosition) == pos)
    
    subsetOppData = subsetOppData[order(subsetOppData$GameDate , decreasing = TRUE ),]
    if(nrow(subsetOppData) > 100){
      subsetOppData = subsetOppData[0:50,]
    }
    
    #### How many points have been allowed
    for (column in 25:length(colnames(temp)) ){
      #print(colnames(temp)[column])
      col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
      
      temp[, colnames(temp)[column]]  = mean(subsetOppData[, col])
    }
    
    DefensiveStatsNHLToday = rbind(temp, DefensiveStatsNHLToday)
  }
  
}

DefensiveStatsNHLToday[is.na(DefensiveStatsNHLToday)] = 0
DefensiveStatsNHLToday[is.null(DefensiveStatsNHLToday)] = 0
######### Offensive Stats
TodaysPlayers = subset(NHLTableData, NHLTableData$Team %in% TodaysGamesNHL$Team
                         & as.Date(NHLTableData$GameDate) > as.Date("2019-10-25") )
TodaysPlayers = rbind(TodaysPlayers, subset(NHLTableData, NHLTableData$Team %in% TodaysGamesNHL$Opp
                                            & as.Date(NHLTableData$GameDate) > as.Date("2019-10-25") ))

allPlayers = unique(TodaysPlayers$PlayerName)
OffensiveStatsNHLToday = OffensiveStatsNHL[1, ]

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(NHLTableData, NHLTableData$PlayerName == player)  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  # DateLevels = factor(c(levels(DateLevels),substring(Sys.time(),0,10)))
  print(player)
  ## Iterate over date
    # Iterate over each date
    temp = OffensiveStatsNHL[1,]
    subsetPlayerData = subset(NHLTableData, NHLTableData$PlayerName == player 
                              & as.Date(NHLTableData$GameDate) < as.Date(TodaysDate) 
                              & as.Date(NHLTableData$GameDate) > (as.Date(TodaysDate) - 30)
    )  
    subsetPlayerData = subsetPlayerData[order(subsetPlayerData$GameDate , decreasing = TRUE ),]
    if(nrow(subsetPlayerData) > 10){
      subsetPlayerData = subsetPlayerData[0:10,]
    }
    
    currentGame = TodaysGamesNHL[TodaysGamesNHL$Team == subsetPlayerData$Team[1],]
    if(nrow(currentGame) == 0){
      Opp = TodaysGamesNHL[TodaysGamesNHL$Opp == subsetPlayerData$Team[1],]$Team
    }
    else{
      Opp = currentGame$Opp
    }
    
    
    temp$GameDate = TodaysDate
    temp$PlayerName = player
    temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
    temp$Team = as.character(subsetPlayerData$Team[1])
    temp$Opp = as.character(Opp)     
    temp$MP = mean(as.numeric(subsetPlayerData$MP))/60
    temp$HW = 0

    #### How good the player is last 30 days
    for (column in 8:(length(colnames(temp)) - 6) ){
      print(colnames(temp)[column])
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    ### Opposing Team stats
    currentOppPlayers = unique(NHLTableData[NHLTableData$Team == Opp, ]$PlayerName)
    # (subset(NHLTableData, NHLTableData$Team == Opp)$PlayerName) 
    
    currentOppPlayers = subset(NHLTableData, NHLTableData$PlayerName %in% currentOppPlayers 
                               & as.Date(NHLTableData$GameDate) < as.Date(TodaysDate)
                               & as.Date(NHLTableData$GameDate) > (as.Date(TodaysDate) - 15))
    
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
    temp$DKP = 0
    temp$TotalGoals = 0
    
    OffensiveStatsNHLToday = rbind(temp, OffensiveStatsNHLToday)
}

OffensiveStatsNHLToday$GameDate = as.character(OffensiveStatsNHLToday$GameDate)
OffensiveStatsNHLToday[is.na(OffensiveStatsNHLToday)] = 0
OffensiveStatsNHLToday[is.null(OffensiveStatsNHLToday)] = 0


OffensiveStatsNHL = rbind(OffensiveStatsNHLToday , OffensiveStatsNHL)
DefensiveStatsNHL = rbind(DefensiveStatsNHLToday , DefensiveStatsNHL)
OffensiveStatsNHL$GameDate = as.Date(OffensiveStatsNHL$GameDate)
DefensiveStatsNHL$GameDate = as.Date(DefensiveStatsNHL$GameDate)



#############################################################################################
#############################################################################################
####################################Prediction###############################################
CombinedStatsNHL = merge(x = OffensiveStatsNHL, y = DefensiveStatsNHL, by.x = c("GameDate", "PlayerPosition", "Opp"), 
                         by.y = c("GameDate", "PlayerPosition", "Team"))
CombinedStatsNHL[is.na(CombinedStatsNHL)] = 0
CombinedStatsNHL[is.null(CombinedStatsNHL)] = 0

CombinedStatsNHL = merge(x = CombinedStatsNHL, y = GoalieStatsNHL, by.x = c("GameDate", "Opp"), 
                         by.y = c("GameDate", "Team"))

CombinedStatsNHL[is.na(CombinedStatsNHL)] = 0
CombinedStatsNHL[is.null(CombinedStatsNHL)] = 0


# write.csv(CombinedStats, file = "CombinedStatsNHL.csv")

DateCheck = Sys.Date()
allPlayers = unique(CombinedStatsNHL$PlayerName)

Results = data.frame( RFPred = numeric(), player = factor(), position = factor(), salary = numeric(), 
                      date = factor(), MP = numeric(), team = factor(),
                      Actual = numeric(), Opp = numeric(), ShotsTaken = numeric(), Goals = numeric())

allPlayers = subset(CombinedStatsNHL, as.Date(CombinedStatsNHL$GameDate) == DateCheck)$PlayerName

##############################################################
################## NHL Results ###############################
for (player in allPlayers){
  print(player)
  Data_Cleaned_Test = subset(CombinedStatsNHL, as.Date(CombinedStatsNHL$GameDate) == as.Date(DateCheck) 
                             & CombinedStatsNHL$PlayerName == as.character(player) )
  
  Data_Cleaned_Train = subset(CombinedStatsNHL, as.Date(CombinedStatsNHL$GameDate) < as.Date(DateCheck)
                              & as.Date(CombinedStatsNHL$GameDate) > (as.Date(DateCheck) - 30)
                              & CombinedStatsNHL$PlayerName == as.character(player) )
  
  Actual = subset(NHLTableData, as.Date(NHLTableData$GameDate) == as.Date(DateCheck) 
                  & NHLTableData$PlayerName == as.character(player) )
  
  Actual = Actual[1,]
  Data_Cleaned_Train[is.na(Data_Cleaned_Train)] = 0
  Data_Cleaned_Test[is.na(Data_Cleaned_Test)] = 0
  
  if (nrow(Data_Cleaned_Train) == 0 | nrow(Data_Cleaned_Test) == 0){
    next;
  }
  # "MP.x","HW.x", "Goals.x",  "Assists.x", "Points.x","Penalties.x","ShotsOnGoal.x", 
  # "Hits.x","Blocks.x", "FaceOffPer.x", "GoalsOpp.x", "FaceOffPerOpp", "EVAssitsOpp.x", 
  # "ShotsOnGoalOpp.x","HitsOpp.x","BlocksOpp.x","Goals.y",  "Assists.y","Points.y", "Penalties.y",  
  # "MP.y","Hits.y","Blocks.y","FaceOffPer.y",  "GoalsOpp.y", "AssistsOpp",
  # "ShotsOnGoalOpp.y","HitsOpp.y","BlocksOpp.y","GoalsAgainst", "ShotsAgainst",
  # "Saves","ShoutOuts", "Hits","Blocks","ShotsOpp","HitsOpp"
  
  rf = randomForest(Data_Cleaned_Train[,c("MP.x","HW", "Goals.x",  "Assists.x", "Points.x","Penalties.x","ShotsOnGoal.x", 
                                          "Hits.x","Blocks.x", "FaceOffPer.x", "GoalsOpp.x", "FaceOffPerOpp", "EVAssitsOpp.x", 
                                          "ShotsOnGoalOpp.x","HitsOpp.x","BlocksOpp.x","Goals.y",  "Assists.y","Points.y", "Penalties.y",  
                                          "MP.y","Hits.y","Blocks.y","FaceOffPer.y",  "GoalsOpp.y", "AssistsOpp",
                                          "ShotsOnGoalOpp.y","HitsOpp.y","BlocksOpp.y")], 
                    y = Data_Cleaned_Train[,c("DKP")], ntree=50 ,type='regression')
  
  RFPred = predict( rf,  Data_Cleaned_Test[,c("MP.x","HW", "Goals.x",  "Assists.x", "Points.x","Penalties.x","ShotsOnGoal.x", 
                                              "Hits.x","Blocks.x", "FaceOffPer.x", "GoalsOpp.x", "FaceOffPerOpp", "EVAssitsOpp.x", 
                                              "ShotsOnGoalOpp.x","HitsOpp.x","BlocksOpp.x","Goals.y",  "Assists.y","Points.y", "Penalties.y",  
                                              "MP.y","Hits.y","Blocks.y","FaceOffPer.y",  "GoalsOpp.y", "AssistsOpp",
                                              "ShotsOnGoalOpp.y","HitsOpp.y","BlocksOpp.y")] ,type = c("response") )
  
  rfGoals = randomForest(Data_Cleaned_Train[,c("MP.x","HW", "Goals.x",  "Assists.x", "Points.x","Penalties.x","ShotsOnGoal.x", 
                                               "Hits.x","Blocks.x", "FaceOffPer.x", "GoalsOpp.x", "FaceOffPerOpp", "EVAssitsOpp.x", 
                                               "ShotsOnGoalOpp.x","HitsOpp.x","BlocksOpp.x","Goals.y",  "Assists.y","Points.y", "Penalties.y",  
                                               "MP.y","Hits.y","Blocks.y","FaceOffPer.y",  "GoalsOpp.y", "AssistsOpp",
                                               "ShotsOnGoalOpp.y","HitsOpp.y","BlocksOpp.y")], 
                         y = Data_Cleaned_Train[,c("TotalGoals")], ntree=50 ,type='regression')
  
  RFPredGoals = predict( rfGoals,  Data_Cleaned_Test[,c("MP.x","HW", "Goals.x",  "Assists.x", "Points.x","Penalties.x","ShotsOnGoal.x", 
                                                        "Hits.x","Blocks.x", "FaceOffPer.x", "GoalsOpp.x", "FaceOffPerOpp", "EVAssitsOpp.x", 
                                                        "ShotsOnGoalOpp.x","HitsOpp.x","BlocksOpp.x","Goals.y",  "Assists.y","Points.y", "Penalties.y",  
                                                        "MP.y","Hits.y","Blocks.y","FaceOffPer.y",  "GoalsOpp.y", "AssistsOpp",
                                                        "ShotsOnGoalOpp.y","HitsOpp.y","BlocksOpp.y")] ,type = c("response") )
  
  
  Prediction2 = as.data.frame(RFPred)
  Prediction2["player"] = player
  Prediction2["position"] = Data_Cleaned_Test$PlayerPosition
  Prediction2["salary"] = Prediction2$RFPred * 1000/2
  Prediction2["MP"] = Data_Cleaned_Test$MP.x
  Prediction2["Team"] = Data_Cleaned_Test$Team
  Prediction2$Actual = Actual$DKP.x
  Prediction2["Opp"] = Data_Cleaned_Test$Opp
  Prediction2["date"] = as.Date(DateCheck)
  Prediction2["ShotsTaken"] = Data_Cleaned_Test$ShotsOnGoal.x
  
  # # Get preivous teams against this position ( last 20 days )
  # previousTeams = subset(NBAAllData, NBAAllData$Opp.x == as.character(Data_Cleaned_Test$Opp) 
  #                        & as.Date(NBAAllData$Date) > (as.Date(DateCheck) - 20) & as.Date(NBAAllData$Date) < (as.Date(DateCheck))
  #                        & NBAAllData$Position == Data_Cleaned_Test$PlayerPosition
  #                        & NBAAllData$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) - 1)
  #                        & NBAAllData$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) + 1))
  # i = 0
  # 
  # while(nrow(previousTeams) < 4){
  #   i = i + 1
  #   # Get preivous teams against this position ( last 20 days )
  #   previousTeams = subset(NBAAllData, NBAAllData$Opp.x == as.character(Data_Cleaned_Test$Opp) 
  #                          & as.Date(NBAAllData$Date) > (as.Date(DateCheck) - 20)
  #                          & as.Date(NBAAllData$Date) < (as.Date(DateCheck))
  #                          & NBAAllData$Position == Data_Cleaned_Test$PlayerPosition
  #                          & NBAAllData$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) - i*0.5)
  #                          & NBAAllData$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x)+ i*0.5)
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
  #     previousTeamData = subset(NBAAllData, 
  #                               as.Date(NBAAllData$Date) == as.Date(datejk)
  #                               & NBAAllData$Tm == tm
  #                               & NBAAllData$PTS > previousTeams$PTS[jk] )
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
  # 
  # Prediction2["simpleProjection"] = Prediction2$pointsAllowedAgainstPosition * 1 + Data_Cleaned_Test$ThreeP.x * .5 + Data_Cleaned_Test$AST.x * 1.25 +
  #   Data_Cleaned_Test$TRB.x * 1.5 + (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x) * 2 - 3
  # 
  Results = rbind(Results, Prediction2)
}

# dbWriteTable(con, name = "NBA_DK_Prediction", value = Results, row.names = FALSE, append = TRUE)  

