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

##########################################
##########################################

OffensiveStatsNCAA = subset(OffensiveStatsNCAA, as.Date(OffensiveStatsNCAA$Date) <= max(as.Date(AllDataNCAA$Date)))
DefensiveStatsNCAA = subset(DefensiveStatsNCAA, as.Date(DefensiveStatsNCAA$Date) <= max(as.Date(AllDataNCAA$Date)))
PositionsAll = "G"

#################################################################
###################### Current NCAA #############################
DefensiveStatsNCAACurrent = DefensiveStatsNCAA[0,]

for (eachTeam in unique(AllDataNCAA$School)) {
  # Iterate over each team
  subsetTeamData = subset(AllDataNCAA, AllDataNCAA$School == eachTeam)  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetTeamData[order(subsetTeamData$Date , decreasing = FALSE ),]$Date))
  DefensiveStatsMaxDate = max(as.Date(subset(DefensiveStatsNCAA,
                          DefensiveStatsNCAA$Tm == eachTeam)$Date ), na.rm =  TRUE)
  
  DateLevels = DateLevels[as.Date(DateLevels) > DefensiveStatsMaxDate]
  if (length(DateLevels) == 0){
    next;
  }
  
  print(eachTeam)
  pos = "G"
  for (date in 1:length(DateLevels)){
    # Iterate over each date
    temp = DefensiveStatsNCAA[1,]
    subsetTeamData = subset(AllDataNCAA, AllDataNCAA$School == eachTeam 
                            & as.Date(AllDataNCAA$Date) < as.Date(DateLevels[date]) &
                              as.Date(AllDataNCAA$Date) > (as.Date(DateLevels[date]) - 30)
    )  
    
    CurrentGame = subset(AllDataNCAA, AllDataNCAA$School == eachTeam 
                         & as.Date(AllDataNCAA$Date) == as.Date(DateLevels[date]))  
    if (nrow(subsetTeamData) == 0){
      next
    }
    
    AG = aggregate(subsetTeamData[,11:ncol(subsetTeamData)], by = list(subsetTeamData$PlayerName), FUN = mean, na.rm = TRUE)
    AG = subset(AG, AG$MP > 10)
    
    temp$Date = DateLevels[date]
    temp$Tm = eachTeam
    temp$Pos = pos
    #### How good the defense is
    for (column in 4:22){
      temp[, colnames(temp)[column]]  = sum(AG[, colnames(temp)[column]])
    }
    
    subsetOppData = subset(AllDataNCAA, AllDataNCAA$Opponent %in% unique(CurrentGame$Opponent) 
                           & as.Date(AllDataNCAA$Date) < as.Date(DateLevels[date]) 
                           & as.Date(AllDataNCAA$Date) > (as.Date(DateLevels[date]) - 30) 
    )
    
    if (nrow(subsetOppData) == 0){
      subsetOppData = subsetTeamData[1,]
      subsetOppData[,11:length(subsetOppData)] = 0
    }
    
    AG = aggregate(subsetOppData[,11:ncol(subsetOppData)], by = list(subsetOppData$PlayerName), FUN = mean, na.rm = TRUE)
    AG = subset(AG, AG$MP > 10)
    
    
    #### How many points have been allowed
    for (column in 25:length(colnames(temp)) ){
      print(colnames(temp)[column])
      col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
      
      temp[, colnames(temp)[column]]  = sum(AG[, col])
      
    }
    
    DefensiveStatsNCAACurrent = rbind(temp, DefensiveStatsNCAACurrent)
    ## Iterate over date
  }
}

DefensiveStatsNCAA = rbind(DefensiveStatsNCAACurrent, DefensiveStatsNCAA)
write.csv(DefensiveStatsNCAA, file = "DefensiveStatsNCAA_All.csv")


### Get Offensive Stats for each player
OffensiveStatsNCAACurrent = OffensiveStatsNCAA[0,]
allPlayers = unique(subset(AllDataNCAA, as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 30)
                           & AllDataNCAA$School %in% game1))

for (player in 1:nrow(allPlayers)) {
  player = allPlayers[player,]
  
  ## Get Playerdata
  subsetPlayerData = subset(AllDataNCAA, AllDataNCAA$PlayerName == player$PlayerName & AllDataNCAA$School == player$School)
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  if(paste(player$PlayerName , player$School ) %in% 
     paste(OffensiveStatsNCAACurrent$PlayerName, OffensiveStatsNCAACurrent$Tm)){
    next
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$Date, decreasing = FALSE ),]$Date))  
  
  DefensiveStatsMaxDate = max(as.Date(subset(OffensiveStatsNCAA, OffensiveStatsNCAA$PlayerName == player$PlayerName
                        & OffensiveStatsNCAA$Tm == player$School)$Date ), na.rm =  TRUE)
  
  DateLevels = DateLevels[as.Date(DateLevels) > DefensiveStatsMaxDate]
  if (length(DateLevels) == 0){
    next;
  }
  print(player$PlayerName)
  # Add current Date
  for (date in 1:length(DateLevels)){
    
    
    #### Iterate over each date ###
    temp = OffensiveStatsNCAA[1,]
    subsetPlayerData = subset(AllDataNCAA, AllDataNCAA$PlayerName == player$PlayerName
                              & AllDataNCAA$School == player$School 
                              & as.Date(AllDataNCAA$Date) < as.Date(DateLevels[date]) 
                              & as.Date(AllDataNCAA$Date) > (as.Date(DateLevels[date]) - 300))  
    
    currentGame = subset(AllDataNCAA, AllDataNCAA$PlayerName == player$PlayerName & player$School == AllDataNCAA$School
                         & as.Date(AllDataNCAA$Date) == as.Date(DateLevels[date]) 
    )
    if (nrow(currentGame) == 0 ){
      next
    }
    
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
    
    
    temp$Date = DateLevels[date]
    temp$PlayerName = player$PlayerName
    temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
    temp$Tm = as.character(lastTeam[length(lastTeam)])
    temp$TotalPoints = currentGame$TotalPoints[1]
    #### How good the defense is
    for (column in 8:length(colnames(temp))){
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    
    
    OffensiveStatsNCAACurrent = rbind(temp, OffensiveStatsNCAACurrent)   
     
  }
  ## Iterate over date
}


OffensiveStatsNCAA = rbind(OffensiveStatsNCAACurrent, OffensiveStatsNCAA)
write.csv(OffensiveStatsNCAA, file = "OffensiveStatsNCAA_All.csv")


####################################################################################
####################################################################################
### Get Defensive stats for each team
TodaysSchools = unique(subset(AllDataNCAA, AllDataNCAA$School %in% game1)$School)
DefensiveStatsNCAAToday = DefensiveStatsNCAA[0,]
PositionsAll = "G"
for (eachTeam in TodaysSchools) {
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
    if (nrow(subsetTeamData) == 0){
      next
    }
    
    AG = aggregate(subsetTeamData[,11:ncol(subsetTeamData)], by = list(subsetTeamData$PlayerName), FUN = mean, na.rm = TRUE)
    AG = subset(AG, AG$MP > 10)
        
    
    temp$Date = TodayDate
    temp$Tm = eachTeam
    temp$Pos = pos
    #### How good the defense is
    for (column in 4:22){
      temp[, colnames(temp)[column]]  = sum(AG[, colnames(temp)[column]])
    }
    
    num = which(as.character(eachTeam[length(eachTeam)]) == game1) 
    if (num %% 2 == 0){
      Opp = game1[num - 1] 
    }
    else{
      Opp = game1[num + 1]
    }
    
    subsetOppData = subset(AllDataNCAA, AllDataNCAA$Opponent %in% unique(Opp) 
                           & as.Date(AllDataNCAA$Date) < as.Date(TodayDate) 
                           & as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 5) &
                             as.character(AllDataNCAA$PlayerPosition) == pos )
    
    if (nrow(subsetOppData) == 0){
      subsetOppData = subsetTeamData[1,]
      subsetOppData[,11:length(subsetOppData)] = 0
    }
    
    AG = aggregate(subsetOppData[,11:ncol(subsetOppData)], by = list(subsetOppData$PlayerName), FUN = mean, na.rm = TRUE)
    AG = subset(AG, AG$MP > 10)
    
    #### How many points have been allowed
    for (column in 25:length(colnames(temp)) ){
      print(colnames(temp)[column])
      col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
      temp[, colnames(temp)[column]]  = sum(AG[, col])
    }
    
    DefensiveStatsNCAAToday = rbind(temp, DefensiveStatsNCAAToday)
  }
  ## Iterate over date
}

DefensiveStatsNCAA = rbind(DefensiveStatsNCAAToday, DefensiveStatsNCAA)


allPlayers = unique(subset(AllDataNCAA, as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 60)
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
  
  if(paste(player$PlayerName , player$School ) %in% paste(OffensiveStatsNCAAToday$PlayerName, OffensiveStatsNCAAToday$Tm)){
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
                            & as.Date(AllDataNCAA$Date) > (as.Date(TodayDate) - 30)
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
TodayDate = Sys.Date()
CombinedStats = merge(OffensiveStatsNCAA, DefensiveStatsNCAA, by.x = c("Date", "Opp"), by.y = c("Date", "Tm" ))
allPlayers = unique(CombinedStats$PlayerName)
DateCheck = TodayDate

Results = data.frame( RFPred = numeric(), player = factor(), position = factor(), salary = numeric(),
                      MP = numeric(), team = factor(), pointsScored = numeric() , assists = numeric(),
                      rebound = numeric(), pointsAllowedAgainstPosition = numeric(),
                      playerList = factor(), TeamScore = numeric(), Actual = numeric(),
                      simpleProjection = numeric(), Opp = numeric())

allPlayers = unique(subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck)))
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
  
  # if (Data_Cleaned_Test$MP < 10 ){
  #   next;
  # }
  
  # "FG.x",   "FGA.x",  "FGper.x","ThreeP.x",   "ThreePA.x", 
  # "ThreePper.x","FT.x",   "FTA.x",  "FTper.x",
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

dbSendQuery(con, "Delete From NCAA_DK_Prediction")
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

dbSendQuery(con, "Delete From  NCAA_DK_Prediction2")
dbWriteTable(con, name = "NCAA_DK_Prediction2", value = data.frame(NewResults), row.names = FALSE, append = TRUE)  


