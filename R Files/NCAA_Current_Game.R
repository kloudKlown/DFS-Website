setwd("C:/Users/suhas/Source/Repos/kloudKlown/DFS-Website/R Files")
source('RIncludes.R')
source('NCAA_TodayGames.R')

library(odbc)
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "localhost",
                 Database = "NBA",
                 Trusted_Connection = "True",
                 Port = 1433)
BBSavantPlayer = dbSendQuery(con, "Select * From [NCAA_PlayerLog]")
AllDataNCAA = dbFetch(BBSavantPlayer)
dbClearResult(BBSavantPlayer)

AllDataNCAA$School = tolower(AllDataNCAA$School)
AllDataNCAA$Opponent = tolower(AllDataNCAA$Opponent)
colnames(AllDataNCAA)[colnames(AllDataNCAA)=="ï..Date"] <- "Date"
colnames(AllDataNCAA)[colnames(AllDataNCAA)=="ï..PlayerName"] <- "PlayerName"
AllDataNCAA$PlayerName = gsub("(?=[A-Z])", " ", AllDataNCAA$PlayerName , perl = TRUE)
AllDataNCAA$PlayerName = gsub("^\\s", "", AllDataNCAA$PlayerName , perl = TRUE)
# AllDataNCAA[AllDataNCAA == "NULL"] = 0
AllDataNCAA$Date = as.Date(AllDataNCAA$Date)

# colnames(AllDataNCAA)[colnames(AllDataNCAA)=="oneGS"] <- "Team"
AllDataNCAA$PlayerPosition = toupper(AllDataNCAA$PlayerPosition)
AllDataNCAA$PlayerPosition = gsub("/[A-Z]*", "", (AllDataNCAA$PlayerPosition) , perl = TRUE)
AllDataNCAA[is.na(AllDataNCAA)] = 0
AllDataNCAA[is.null(AllDataNCAA)] = 0
AllDataNCAA$TotalPoints = AllDataNCAA$FT * 1 + AllDataNCAA$TwoP * 2 + AllDataNCAA$ThreeP * 3

TodayDate = Sys.Date()
print(TodayDate)
OffensiveStatsNCAA = read.csv('OffensiveStatsNCAA_All.csv')
DefensiveStatsNCAA = read.csv('DefensiveStatsNCAA_All.csv')
DefensiveStatsNCAA = subset(DefensiveStatsNCAA, select = -X)
OffensiveStatsNCAA = subset(OffensiveStatsNCAA, select = -X)
##########################################
##########################################

NCAAShotData = dbSendQuery(con, paste("Select 
	SUM(PTS) Points, cast([Date] as date) GameDate , Lower(School) Tm, lower(Opponent) Opp, 
	CASE	
		WHEN blank = '0'
			THEN '2'
		WHEN blank = '@'
			THEN '0'
		WHEN blank = 'N'
			THEN '1'
	END HW,
	blank2 WL
From 
	NCAA_PlayerLog 
WHERE
	[date] > '2018-11-07'
GROUP BY 
	[Date], School, Opponent, blank, blank2
ORDER BY
	[Date]"))
GameTotals = dbFetch(NCAAShotData)
dbClearResult(NCAAShotData)
rm(NCAAShotData)

GameTotals$GameDate = as.Date(GameTotals$GameDate)
DefensiveStatsNCAA$Date = as.Date(DefensiveStatsNCAA$Date)
DataNCAAPoints = GameTotals[1,]
DataNCAAPoints$Wins = 0
DataNCAAPoints$Loss = 0
DataNCAAPoints$WinD = 0
DataNCAAPoints$LossD = 0
DataNCAAPoints$Actual = 0
allTeams = unique(GameTotals$Tm)

# write.csv(DataNCAAPoints, file = "DataNCAAPoints.csv")
# DataNCAAPoints = read.csv('DataNCAAPoints.csv')
# DataNCAAPoints = subset(DataNCAAPoints, select = -X)


for (team in allTeams) {
  game = subset(GameTotals, GameTotals$Tm == team)
  DateLevels = as.factor(unique(game[order(game$GameDate , decreasing = FALSE ),]$GameDate))
  # Ignore already contained dates
  if(nrow(DataNCAAPoints[DataNCAAPoints$Tm == team,]) != 0){
    DateLevels = DateLevels[as.Date(DateLevels) > max(DataNCAAPoints[DataNCAAPoints$Tm == team,]$GameDate)]  
  }
  
  
  
  for (gameDate in DateLevels) {
    print(gameDate)
    game = subset(GameTotals, GameTotals$Tm == team & as.Date(GameTotals$GameDate) < as.Date(gameDate)) # all games before the date
    currentGame = subset(GameTotals, GameTotals$Tm == team & as.Date(GameTotals$GameDate) == as.Date(gameDate)) # Current game
    if (nrow(game) == 0 | nrow(currentGame) != 1 ){
      next
    }
    
    game = game[order(game$GameDate , decreasing = FALSE ),] # Order by Date
    if (nrow(game) > 11){
      game = game[(nrow(game)-10):nrow(game),] # Get last 10 games  
    }
    temp = game[1,]
    temp$Wins = nrow(game[game$WL == "W",])
    temp$Loss = nrow(game[game$WL == "L",])
    bothTeams = merge(game, GameTotals, by.x = c("GameDate", "Tm"), by.y = c("GameDate", "Opp"))
    temp$WinD = median(bothTeams[bothTeams$WL.x == "W",]$Points.x - bothTeams[bothTeams$WL.x == "W",]$Points.y)
    temp$LossD = median(bothTeams[bothTeams$WL.x == "L",]$Points.x - bothTeams[bothTeams$WL.x == "L",]$Points.y)

    temp$GameDate = gameDate
    temp$Opp = currentGame$Opp
    temp$Points = mean(game$Points)
    temp$HW = currentGame$HW
    temp$Actual = currentGame$Points
    DataNCAAPoints = rbind(temp, DataNCAAPoints)
  }
  rm(temp)
  rm(game)
  rm(currentGame)
  rm(DateLevels)
  rm(bothTeams)
}
DataNCAAPoints[is.na(DataNCAAPoints)] = 0




CombinedStats = merge(DefensiveStatsNCAA, DataNCAAPoints,
      by.x = c("Date", "Tm"), by.y = c("GameDate", "Tm"))

predictionMatrix_Diff =c("FG","FGA","FGper","TwoP","TwoPper","ThreeP","ThreePA","ThreePper",
                         "FT","FTA","FTper","ORB","DRB","TRB","AST","STL","BLK","TOV",
                         "PF","GmSc","plusMinus","FGAOpp","ThreePAOpp","FTAOpp","TRBOpp",
                         "ASTOpp","STLOpp","BLKOpp","TOVOpp", "Points", "Wins", "Loss", "WinD","LossD")

Results = data.frame(RFPred = numeric(), Team = factor(), Actual = numeric(),Opp = factor(),
                     simpleProjection = numeric(), Opp = numeric(), GameDate = factor(),
                     OppRFPred = numeric(), OppActual = numeric())

for (i in 1:60) {
  
  DateCheck = Sys.Date() - i
  allTeams = subset(DefensiveStatsNCAA, DefensiveStatsNCAA$Date == as.Date(DateCheck))
  allTeams = unique(allTeams$Tm)
  
  for (team in allTeams) {
    print(team)
    
    Data_Cleaned_Test = subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck) 
                               & CombinedStats$Tm == as.character(team))
    
    Data_Cleaned_Train = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                                & CombinedStats$Tm == as.character(team)
                                & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 300) )
    
    Opponent = subset(AllDataNCAA, AllDataNCAA$School == as.character(team)
                      & as.Date(AllDataNCAA$Date) == as.Date(DateCheck))$Opponent
    Opponent = unique(Opponent)
    currentGame = subset(GameTotals, GameTotals$Tm == team & 
                           as.Date(GameTotals$GameDate) == as.Date(DateCheck)) # Current game
    
    if(nrow(Data_Cleaned_Train) < 2){
      next
    }
    
    
    Data_Cleaned_Train = Data_Cleaned_Train[order(Data_Cleaned_Train$Date , decreasing = TRUE ),]
    
    if(nrow(Data_Cleaned_Train) > 50){
      Data_Cleaned_Train = Data_Cleaned_Train[0:50,]
    }
    
    if (nrow(Data_Cleaned_Train) == 0 | nrow(Data_Cleaned_Test) == 0 | length(Data_Cleaned_Train$Date > as.Date('2019-08-11')) == 0){
      next;
    }
    
    rf = randomForest( Data_Cleaned_Train[,predictionMatrix_Diff], 
                       y = Data_Cleaned_Train[,c("Actual")], ntree=50, type='regression')
    
    RFPred = predict( rf,  Data_Cleaned_Test[,predictionMatrix_Diff] ,type = c("response") )
    
    Prediction2 = as.data.frame(RFPred)
    Prediction2["simpleProjection"] = Data_Cleaned_Test$FG*2 + Data_Cleaned_Test$ThreeP*3 + Data_Cleaned_Test$FT
    Prediction2["position"] = Data_Cleaned_Test$PlayerPosition
    Prediction2["Team"] = Data_Cleaned_Test$Tm
    Prediction2["Actual"] = currentGame$Points
    Prediction2["Opp"] = Opponent
    Prediction2["GameDate"] = DateCheck
    Prediction2$OppActual = 0
    Prediction2$OppRFPred = 0
    Results = rbind(Results, Prediction2)
    
  }
  
  for (team in allTeams) {
    pl = subset(Results, Results$Opp == as.character(team) & as.Date(Results$GameDate) == as.Date(DateCheck))
    if(nrow(pl) == 0){
      next
    }
    Results[Results$Team == as.character(team),]$OppRFPred = pl$RFPred
    Results[Results$Team == as.character(team),]$OppActual = pl$Actual
  }
  
  
}



