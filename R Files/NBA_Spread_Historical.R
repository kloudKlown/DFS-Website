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


######################################################
############### Team Defensive stats ######################
######################################################
DefensiveStats = data.frame(matrix(ncol = 38))
colnames(DefensiveStats) = c("Tm","PlayerPosition" ,"Date","FG","FGA","ThreeP","ThreePA",
                             "FT","FTA","ORB","DRB","TRB","AST",
                             "STL","BLK","TOV","PF", "PTS", "TSPer","eFGPer","ORBPer",
                             "DRBPer","TRBPer","ASTPer","STLPer","BLKPer","TOVPer","USGPer","ORTGPer","DRTGPer",
                             "FGAOpp", "ThreePAOpp", "FTAOpp", "TRBOpp","ASTOpp","STLOpp","BLKOpp","TOVOpp")

DefensiveStats[is.na(DefensiveStats)] = 0

PositionsAll = unique( NBAAllData$Position )
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
colnames(OffensiveStats) = c("PlayerName", "Tm", "PlayerPosition" , "Date", "Opp",  "TotalPoints","DKP",
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
    
    OffensiveStats = rbind(temp, OffensiveStats)
  }
  ## Iterate over date
  
}

OffensiveStats[is.na(OffensiveStats)] = 0
OffensiveStats[is.null(OffensiveStats)] = 0
write.csv(OffensiveStats, file = "OffensiveStats_All.csv")

##########################################################

OffensiveStats = read.csv('OffensiveStats_All.csv')
DefensiveStats = read.csv('DefensiveStats_All.csv')

## varclus Batters
spearmanP = varclus(as.matrix(CombinedStats[,c("FG.x","ThreeP.x",
                                               "FT.x",
                                               "TRB.x","STL.x","TOV.x","PF.x",
                                               "TSPer.x","ORBPer.x","TRBPer.x","ASTPer.x",
                                               "STLPer.x","BLKPer.x","TOVPer.x","USGPer.x","ORTGPer.x","DRTGPer.x",
                                               "ThreeP.y","FT.y","AST.y","STL.y",
                                               "TOV.y","PF.y","PTS",
                                               "TRBPer.y","STLPer.y","BLKPer.y","TOVPer.y",
                                               "USGPer.y","ORTGPer.y","DRTGPer.y","FGAOpp","ThreePAOpp","FTAOpp",
                                               "TRBOpp","ASTOpp","STLOpp","TOVOpp")] ), similarity = "spearman")
plot(spearmanP)
abline(h=0.3)

################## Results ###############################
CombinedStats = merge(x = OffensiveStats, y = DefensiveStats, by.x = c("Date", "PlayerPosition", "Tm"), 
                      by.y = c("Date", "Pos", "Tm") )

write.csv(CombinedStats, file = "CombinedStats.csv")


allPlayers = unique(CombinedStats$PlayerName)
dbSendQuery(con, "DELETE FROM NBA_DK_Prediction")



for (variable in c(3:365)) {
  DateCheck =   as.Date("2019-10-23") - variable
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
}
##############################################################
##############################################################

