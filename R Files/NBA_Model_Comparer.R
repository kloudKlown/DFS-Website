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
NBAAllData$Date = as.Date(NBAAllData$Date)
OffensiveStats = read.csv('OffensiveStats_All.csv')
DefensiveStats = read.csv('DefensiveStats_All.csv')

OffensiveStats = subset(OffensiveStats, select = -X)
# OffensiveStats = subset(OffensiveStats, select = -X.1)

DefensiveStats = subset(DefensiveStats, select = -X)
# DefensiveStats = subset(DefensiveStats, select = -X.1)


ShotTeamPlayer = dbSendQuery(con, paste("Select CAST(GameDate as date) Date, 
(OU/2 - Line) FVScore, FV,
(OU/2 + Line) DogScore, 
	CASE 
		WHEN FV = Team THEN Opp
		ELSE
			Team
	END Dog
From NBA_Games ORDER BY 1 DESC"))
VegasScore = dbFetch(ShotTeamPlayer)
dbClearResult(ShotTeamPlayer)
rm(ShotTeamPlayer)


DFP1 =  merge(x = DefensiveStats, y = VegasScore, by.x = c("Date", "Tm"),
      by.y = c("Date", "FV" ))
DFP1 = subset(DFP1, select = -Dog)
DFP1["Spread"] = DFP1$FVScore - DFP1$DogScore

DFP2 = merge(x = DefensiveStats, y = VegasScore, by.x = c("Date", "Tm"),
      by.y = c("Date", "Dog" ))
DFP2 = subset(DFP2, select = -FV)
DFP2["Spread"] = DFP2$FVScore - DFP2$DogScore

DefensiveStats = rbind(DFP1, DFP2)



CombinedStats = merge(x = OffensiveStats, y = DefensiveStats, by.x = c("Date", "Pos", "Tm"), 
                      by.y = c("Date", "Pos", "Tm") )

CombinedStats = merge(x = CombinedStats, y = DefensiveStats, by.x = c("Date", "Pos", "Opp"), 
                      by.y = c("Date", "Pos", "Tm") )


DateCheck = Sys.Date() - 4
allPlayers = unique(CombinedStats$PlayerName)

Results = data.frame( RFPred = numeric(), player = factor(), position = factor(), salary = numeric(), 
                      date = factor(),
                      ActualMP = numeric(), MP = numeric(), Team = factor(), pointsScored = numeric() , 
                      assists = numeric(),
                      rebound = numeric(), pointsAllowedAgainstPosition = numeric(), 
                      playerList = factor(), TeamScore = numeric(), Actual = numeric(),
                      simpleProjection = numeric(), Opp = numeric(), comparer = numeric())

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
                    "TRBOpp.y","ASTOpp.y","STLOpp.y","TOVOpp.y", "FVScore.x", "Spread.x")

##########


NBAAllData$DKP = NBAAllData$FT * 1 + (NBAAllData$FG-NBAAllData$ThreeP) * 2 +
  NBAAllData$ThreeP * 3.5 + NBAAllData$AST * 1.5 + NBAAllData$TRB * 1.25 +  NBAAllData$STL * 2 + NBAAllData$BLK * 2 - NBAAllData$TOV * 0.5

DateCheck = Sys.Date() - 12
allPlayers = unique(subset(CombinedStats, as.Date(CombinedStats$Date) == DateCheck)$PlayerName)


for (player in allPlayers){
  print(player)
  Data_Cleaned_Test = subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck) 
                             & CombinedStats$PlayerName == as.character(player) )
 
  Data_Cleaned_Train = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                              & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 300)
                              & CombinedStats$PlayerName == as.character(player) )
  
  
  if (Data_Cleaned_Test$Pos == "PG" | Data_Cleaned_Test$Pos == "SG"){
    Data_Cleaned_Train_Against = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                                        & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 60)
                                        & (CombinedStats$Pos == "PG" | CombinedStats$Pos == "SG")
                                        & CombinedStats$Opp == Data_Cleaned_Test$Opp
    )
    
  }
  else if (Data_Cleaned_Test$Pos == "PF" | Data_Cleaned_Test$Pos == "SF"){
    Data_Cleaned_Train_Against = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                                        & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 60)
                                        & (CombinedStats$Pos == "PF" | CombinedStats$Pos == "SF")
                                        & CombinedStats$Opp == Data_Cleaned_Test$Opp
    )
  }
  else{
    Data_Cleaned_Train_Against = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                                        & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 60)
                                        & (CombinedStats$Pos == "C")
                                        & CombinedStats$Opp == Data_Cleaned_Test$Opp
    )
  }
  

  
  
  Actual = subset(NBAAllData, as.Date(NBAAllData$Date) == as.Date(DateCheck) 
                  & NBAAllData$PlayerName == as.character(player) )
  
  Actual = Actual[1,]
  Data_Cleaned_Train[is.na(Data_Cleaned_Train)] = 0
  Data_Cleaned_Test[is.na(Data_Cleaned_Test)] = 0
  
  if (nrow(Data_Cleaned_Train) == 0 | nrow(Data_Cleaned_Test) == 0){
    next;
  }
  
  RFCollector = c()
  for (variable in 1:2) {
    rf = randomForest(Data_Cleaned_Train[,predictionNames], 
                      y = Data_Cleaned_Train[,c("DKP")], ntree = 500 ,type='regression')
    
    RFPred = predict( rf,  Data_Cleaned_Test[,predictionNames] ,type = c("response") )
    
    RFCollector[variable]  = RFPred
  }
  
  RFcomparer = c()
  for (variable in 1:2) {
    rfA = randomForest(Data_Cleaned_Train_Against[,predictionNames], 
                      y = Data_Cleaned_Train_Against[,c("DKP")], ntree = 500 ,type='regression')
    
    RFPred = predict( rfA,  Data_Cleaned_Test[,predictionNames] ,type = c("response") )
    
    RFcomparer[variable]  = RFPred
  }
  
  rfTP = randomForest(Data_Cleaned_Train[,predictionNames], 
                      y = Data_Cleaned_Train[,c("TotalPoints")], ntree=50 ,type='regression')
  
  RFPredTP = predict( rfTP,  Data_Cleaned_Test[,predictionNames] ,type = c("response") )
  
  Prediction2 = Results[1,]
  Prediction2["RFPred"] = mean(RFCollector)
  Prediction2["comparer"] = mean(RFcomparer)
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

summary(Results$RFPred - Results$Actual)
summary(Results$comparer - Results$Actual)
summary((Results$comparer+Results$RFPred)/2 - Results$Actual)

player = "Alec Burks"
Data_Cleaned_Test = subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck) 
                           & CombinedStats$PlayerName == as.character(player) )

Data_Cleaned_Train = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                            & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 300)
                            & CombinedStats$PlayerName == as.character(player) )


lmModel = rpart(DKP ~ FG.x+ThreeP.x+FT.x+TRB.x+STL.x+TOV.x+PF.x+
               TSPer.x+ORBPer.x+TRBPer.x+ASTPer.x+
               STLPer.x+BLKPer.x+TOVPer.x+USGPer.x+ORTGPer.x+DRTGPer.x+
               ThreeP.y+FT.y+AST.y+STL.y+
               TOV.y+PF.y+TRBPer.y+STLPer.y+BLKPer.y+TOVPer.y+
               USGPer.y+ORTGPer.y+DRTGPer.y+FGAOpp.x+ThreePAOpp.x+FTAOpp.x+
               TRBOpp.x+ASTOpp.x+STLOpp.x+TOVOpp.x+
               FT+AST+STL+TOV+PF+TRBPer+STLPer+BLKPer+TOVPer+
               USGPer+ORTGPer+DRTGPer+FGAOpp.y+ThreePAOpp.y+FTAOpp.y+
               TRBOpp.y+ASTOpp.y+STLOpp.y+TOVOpp.y, data = Data_Cleaned_Train )

predict(lmModel, type = "response", newdata = Data_Cleaned_Test)


nn = nnet(Data_Cleaned_Train[,predictionNames], 
             y = Data_Cleaned_Train[,c("DKP")], size = c(10,10,10,20))
predict(nn, Data_Cleaned_Train[,predictionNames])
