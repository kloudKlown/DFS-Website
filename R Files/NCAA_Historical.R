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
AllDataNCAA[AllDataNCAA == "NULL"] = 0
AllDataNCAA$Date = as.Date(AllDataNCAA$Date)

# colnames(AllDataNCAA)[colnames(AllDataNCAA)=="oneGS"] <- "Team"
AllDataNCAA$PlayerPosition = toupper(AllDataNCAA$PlayerPosition)
AllDataNCAA$PlayerPosition = gsub("/[A-Z]*", "", (AllDataNCAA$PlayerPosition) , perl = TRUE)
AllDataNCAA[is.na(AllDataNCAA)] = 0
AllDataNCAA[is.null(AllDataNCAA)] = 0
AllDataNCAA$TotalPoints = AllDataNCAA$FT * 1 + AllDataNCAA$TwoP * 2 + AllDataNCAA$ThreeP * 3

TodayDate = Sys.Date()
OffensiveStatsNCAA = read.csv('OffensiveStatsNCAA_All.csv')
DefensiveStatsNCAA = read.csv('DefensiveStatsNCAA_All.csv')
DefensiveStatsNCAA = subset(DefensiveStatsNCAA, select = -X)
OffensiveStatsNCAA = subset(OffensiveStatsNCAA, select = -X)

################################################################################################
################################################################################################
###################### NCAA #######################

CombinedStats = merge(OffensiveStatsNCAA, DefensiveStatsNCAA, by.x = c("Date", "Opp"), by.y = c("Date", "Tm" ))
allPlayers = unique(CombinedStats$PlayerName)


Results = data.frame( RFPred = numeric(), player = factor(), Date = factor(), position = factor(), salary = numeric(),
                      MP = numeric(), team = factor(), pointsScored = numeric() , assists = numeric(),
                      rebound = numeric(), pointsAllowedAgainstPosition = numeric(),
                      playerList = factor(), TeamScore = numeric(), Actual = numeric(),
                      simpleProjection = numeric(), Opp = numeric())

allPlayers = unique(subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck)))

for (variable in c(5:40)) {
  DateCheck = TodayDate - variable
  ############################################################
  i = 0
  for (player in 1:nrow(allPlayers)) {
    player = allPlayers[player,]
    i  = i+1
    print(player$PlayerName)
    print(i)
    
    Data_Cleaned_Test = subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck) 
                               & CombinedStats$PlayerName == as.character(player$PlayerName)
                               & CombinedStats$Tm == as.character(player$Tm))
    
    Data_Cleaned_Train = subset(CombinedStats,CombinedStats$PlayerName == as.character(player$PlayerName) 
                                & as.Date(CombinedStats$Date) < as.Date(DateCheck)
                                & CombinedStats$Tm == as.character(player$Tm)
                                & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 300) )
    
    if(nrow(Data_Cleaned_Train) < 10){
      Data_Cleaned_Train = subset(CombinedStats,CombinedStats$Tm == player$Tm 
                                  & as.Date(CombinedStats$Date) < as.Date(DateCheck)
                                  & CombinedStats$Tm == as.character(player$Tm)
                                  & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 30) )  
    }
    
    
    Data_Cleaned_Train = Data_Cleaned_Train[order(Data_Cleaned_Train$Date , decreasing = TRUE ),]
    
    if(nrow(Data_Cleaned_Train) > 50){
      Data_Cleaned_Train = Data_Cleaned_Train[0:50,]
    }
    
    if (nrow(Data_Cleaned_Train) == 0 | nrow(Data_Cleaned_Test) == 0 | length(Data_Cleaned_Train$Date > as.Date('2019-08-11')) == 0){
      next;
    }
   
    rf = randomForest( Data_Cleaned_Train[,c("MP", "Home","ORB.x", "TRB.x",  "AST.x",  "STL.x",  "BLK.x",  
                                             "TOV.x",  "PF.x", "FG.y", "TRB.y","TOV.y",
                                             "FGAOpp", "TRBOpp", "ASTOpp", "STLOpp", "BLKOpp")], 
                       y = Data_Cleaned_Train[,c("TotalPoints")], ntree=500, type='regression')
    
    RFPred = predict( rf,  Data_Cleaned_Test[,c("MP","Home",
                                                "ORB.x", "TRB.x",  "AST.x",  "STL.x",  "BLK.x",  "TOV.x",  "PF.x",
                                                "FG.y", "TRB.y","TOV.y","FGAOpp", "TRBOpp", "ASTOpp", "STLOpp", "BLKOpp")] ,type = c("response") )
    
    
    
    as.data.frame(RFPred)
    
    Prediction2 = as.data.frame(RFPred)
    Prediction2["player"] = player$PlayerName
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
    Prediction2["simpleProjection"] = 0
    Results = rbind(Results, Prediction2)
    
  }
  ##########
  ##########
  dbWriteTable(con, name = "NCAA_DK_Prediction", value = data.frame(Results), row.names = FALSE, append = TRUE)  
  ##########
  ##########
  ##########
  
  teams = unique(Results$Team)
  temp = data.frame(matrix(ncol=1))
  NewResults = temp[0,]
  
  for(t in 1:length(teams) ){
    ResTeam = subset(Results, Results$Team == teams[t])
    OppOnent = subset(Results, Results$Team == as.character(ResTeam[1,]$Opp))
    
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
  dbWriteTable(con, name = "NCAA_DK_Prediction2", value = data.frame(NewResults), row.names = FALSE, append = TRUE)  

}
