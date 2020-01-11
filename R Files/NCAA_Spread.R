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



##############################################################################
###### Get 2017 data to check

AllDataNCAA = subset(AllDataNCAA, as.Date(AllDataNCAA$Date) > "2018-09-01" & as.Date(AllDataNCAA$Date) < "2020-12-01")
# View(AllDataNCAA)

DateLevels = as.factor(unique(AllDataNCAA[order(AllDataNCAA$Date , decreasing = FALSE ),]$Date))
AllDataNCAA[is.na(AllDataNCAA)] = 0
AllDataNCAA[is.null(AllDataNCAA)] = 0
AllColumnNames = colnames(AllDataNCAA)

className = data.frame(sapply(AllDataNCAA, class))
colNames = colnames(AllDataNCAA)
AllDataNCAA[is.na(AllDataNCAA)] = 0
AllDataNCAA[is.null(AllDataNCAA)] = 0


# Defensive stats 3-15, 16-20
DefensiveStatsNCAA = data.frame(matrix(ncol = 32))
colnames(DefensiveStatsNCAA) = c("Tm","Pos" ,"Date","FG","FGA","FGper", "TwoP","TwoPper",
                             "ThreeP","ThreePA","ThreePper","FT","FTA","FTper",
                             "ORB","DRB","TRB","AST","STL","BLK","TOV","PF",
                             "GmSc","plusMinus", "FGAOpp", "ThreePAOpp",
                             "FTAOpp", "TRBOpp","ASTOpp","STLOpp","BLKOpp","TOVOpp")
DefensiveStatsNCAA[is.na(DefensiveStatsNCAA)] = 0

PositionsAll = unique( AllDataNCAA$PlayerPosition )
TeamsNCAA = unique(AllDataNCAA$School)

### Get Defensive stats for each team
for (eachTeam in TeamsNCAA) {
  # Iterate over each team
  subsetTeamData = subset(AllDataNCAA, AllDataNCAA$School == eachTeam)  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  DateLevels = as.factor(unique(subsetTeamData[order(subsetTeamData$Date , decreasing = FALSE ),]$Date))  
  print(eachTeam)
  
  #############################
  ### Position######
  ## Iterate over date
  for (date in 2:length(DateLevels)){
    for (pos in as.factor(PositionsAll) ){
      # Iterate over each date
      temp = DefensiveStatsNCAA[1,]
      ## Make sure do not include this date but eveytyhing before.
      subsetTeamData = subset(AllDataNCAA, AllDataNCAA$School == eachTeam 
                              & as.Date(AllDataNCAA$Date) < as.Date(DateLevels[date]) &
                                as.Date(AllDataNCAA$Date) > (as.Date(DateLevels[date]) - 120) &
                                as.character(AllDataNCAA$PlayerPosition) == pos )
      
      
      temp$Date = DateLevels[date]
      temp$Tm = eachTeam
      temp$Pos = pos
      #### How good the defense is
      for (column in 4:22){
        #print(colnames(temp)[column])
        temp[, colnames(temp)[column]]  = sum(subsetTeamData[, colnames(temp)[column]])
      }
      ## Make sure do not include this date but eveytyhing before.
      subsetOppData = subset(AllDataNCAA, AllDataNCAA$School %in% unique(subsetTeamData$Opp) 
                             & as.Date(AllDataNCAA$Date) < as.Date(DateLevels[date]) 
                             & as.Date(AllDataNCAA$Date) > (as.Date(DateLevels[date]) - 120)
                             & as.character(AllDataNCAA$PlayerPosition) == pos 
      )
      
      #### How many points have been allowed
      for (column in 25:length(colnames(temp)) ){
        col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
        temp[, colnames(temp)[column]]  = sum(subsetOppData[, col])
      }
      
      DefensiveStatsNCAA = rbind(temp, DefensiveStatsNCAA)
    }
    
  }
}

DefensiveStatsNCAA$Date = as.Date(DefensiveStatsNCAA$Date)

############################################################
##################################################
############################################################
############################################################
############################################################
############################################################

write.csv(DefensiveStatsNCAA, file = "DefensiveStatsNCAA_All.csv")


######### Offensive Stats
OffensiveStats = data.frame(matrix(ncol=28))
colnames(OffensiveStats) = c("PlayerName", "Tm", "PlayerPosition" , "Date", "Home",
                             "Opp",  "TotalPoints", "MP","FG","FGA","FGper","TwoP",
                             "TwoPper","TwoPA","ThreeP","ThreePA",
                             "ThreePper","FT","FTA","FTper","ORB","DRB",
                             "TRB","AST","STL","BLK","TOV","PF")

AllDataNCAA$TotalPoints = AllDataNCAA$FT * 1 + AllDataNCAA$TwoP * 2 + AllDataNCAA$ThreeP * 3

allPlayers = unique(AllDataNCAA$PlayerName)

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(AllDataNCAA, AllDataNCAA$PlayerName == player)  
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
    subsetPlayerData = subset(AllDataNCAA, AllDataNCAA$PlayerName == player 
                              & as.Date(AllDataNCAA$Date) < as.Date(DateLevels[date]) 
                              & as.Date(AllDataNCAA$Date) > (as.Date(DateLevels[date]) - 30)
    )  
    
    currentGame = subset(AllDataNCAA, AllDataNCAA$PlayerName == player 
                         & as.Date(AllDataNCAA$Date) == as.Date(DateLevels[date]) 
    ) 
    
    if (nrow(currentGame) == 0 ){
      next
    }
    
    temp$Date = DateLevels[date]
    temp$PlayerName = player
    temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
    temp$Tm = as.character(subsetPlayerData$School[1])
    temp$Opp = as.character(currentGame$Opp[1])     
    temp$TotalPoints = currentGame$TotalPoints[1]
    if (currentGame$blank == '@' | currentGame$blank == 'N'){
      temp$Home = 0
    }
    else{
      temp$Home = 1
    }
    
    
    #### How good the defense is
    for (column in 8:length(colnames(temp))){
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    OffensiveStats = rbind(temp, OffensiveStats)
  }
  ## Iterate over date
  
}

OffensiveStats[is.na(OffensiveStats)] = 0
OffensiveStats[is.null(OffensiveStats)] = 0
OffensiveStatsNCAA = OffensiveStats
write.csv(OffensiveStatsNCAA, file = "OffensiveStatsNCAA_All.csv")

######### Offensive Stats
### Today's games
# OffensiveStats$Date = as.Date(OffensiveStats$Date)

OffensiveStats = subset(OffensiveStats, as.Date(OffensiveStats$Date) != as.Date(TodayDate))
DefensiveStatsNCAA = subset(DefensiveStatsNCAA, as.Date(DefensiveStatsNCAA$Date) != as.Date(TodayDate))


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

allPlayers = unique(AllDataNCAA$PlayerName)

### Get Offensive Stats for each player
for (player in allPlayers) {
  print(player)
  ## Get Playerdata
  subsetPlayerData = subset(AllDataNCAA, AllDataNCAA$PlayerName == player)  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$Date , decreasing = FALSE ),]$Date))  
  # Add current Date
  
  ## Iterate over date
  # Iterate over each date
  temp = OffensiveStats[1,]
  subsetPlayerData = subset(AllDataNCAA, AllDataNCAA$PlayerName == player 
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
  temp$PlayerName = player
  temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
  temp$Tm = as.character(lastTeam[length(lastTeam)])
  temp$TotalPoints = 0
  #### How good the defense is
  for (column in 7:length(colnames(temp))){
    temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
  }
  
  OffensiveStats = rbind(temp, OffensiveStats)
  ## Iterate over date
}

#Combine  Offensive and team defensive stats
# TodayDate = "2019-1-9"
CombinedStats = merge(OffensiveStats, DefensiveStatsNCAA, by = c("Date"), by.x = c("Date", "Opp"), by.y = c("Date", "Tm" ) )
allPlayers = unique(CombinedStats$PlayerName)
DateCheck = TodayDate


Results = data.frame( RFPred = numeric(), player = factor(), position = factor(), salary = numeric(),
                      MP = numeric(), team = factor(), pointsScored = numeric() , assists = numeric(),
                      rebound = numeric(), pointsAllowedAgainstPosition = numeric(),
                      playerList = factor(), TeamScore = numeric(), Actual = numeric(),
                      simpleProjection = numeric(), Opp = numeric())


allPlayers = unique(subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck))$PlayerName)
i = 0
##########

for (player in allPlayers){
  i  = i+1
  print(player)
  print(i)
  Data_Cleaned_Test = subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck) 
                             & CombinedStats$PlayerName == as.character(player) )
  
  Data_Cleaned_Train = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                              & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 365)
                              & CombinedStats$PlayerName == as.character(player) )
  
  if (nrow(Data_Cleaned_Train) == 0 | nrow(Data_Cleaned_Test) == 0 ){
    next;
  }
  
  # if (Data_Cleaned_Test$MP < 10 ){
  #   next;
  # }
  
  # "FG.x",   "FGA.x",  "FGper.x","ThreeP.x",   "ThreePA.x", 
  # "ThreePper.x","FT.x",   "FTA.x",  "FTper.x",
  rf = randomForest( Data_Cleaned_Train[,c("MP", "Home",
                                           "ORB.x", "TRB.x",  "AST.x",  "STL.x",  "BLK.x",  "TOV.x",  "PF.x",  
                                           "plusMinus.x","FG.y", "TRB.y","TOV.y"
  )], 
  y = Data_Cleaned_Train[,c("TotalPoints")], ntree=500
  ,type='regression')
  
  RFPred = predict( rf,  Data_Cleaned_Test[,c("MP","Home",
                                              "ORB.x", "TRB.x",  "AST.x",  "STL.x",  "BLK.x",  "TOV.x",  "PF.x",  
                                              "plusMinus.x","FG.y", "TRB.y","TOV.y"
  )] ,type = c("response") )
  
  
  
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
  
  # Get preivous teams against this position ( last 20 days )
  previousTeams = subset(AllDataNCAA, AllDataNCAA$Opp == as.character(Data_Cleaned_Test$Opp) 
                         & as.Date(AllDataNCAA$Date) > (as.Date(DateCheck) - 60)
                         & as.Date(AllDataNCAA$Date) < (as.Date(DateCheck))
                         & AllDataNCAA$PlayerPosition == Data_Cleaned_Test$PlayerPosition
                         & AllDataNCAA$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) - 1)
                         & AllDataNCAA$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) + 1)
  )
  i = 0
  
  while(nrow(previousTeams) < 4){
    i = i + 1
    # Get preivous teams against this position ( last 20 days )
    previousTeams = subset(AllDataNCAA, AllDataNCAA$Opp == as.character(Data_Cleaned_Test$Opp) 
                           & as.Date(AllDataNCAA$Date) > (as.Date(DateCheck) - 60)
                           & as.Date(AllDataNCAA$Date) < (as.Date(DateCheck))
                           & AllDataNCAA$PlayerPosition == Data_Cleaned_Test$PlayerPosition
                           & AllDataNCAA$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) - i*0.5)
                           & AllDataNCAA$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x)+ i*0.5)
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
      previousTeamData = subset(AllDataNCAA, 
                                as.Date(AllDataNCAA$Date) == as.Date(datejk)
                                & AllDataNCAA$Tm == tm
                                & AllDataNCAA$PTS > previousTeams$PTS[jk] )
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
  
  Prediction2["simpleProjection"] = Prediction2$pointsAllowedAgainstPosition * 1 + Data_Cleaned_Test$ThreeP.x * .5 + Data_Cleaned_Test$AST.x * 1.25 + Data_Cleaned_Test$TRB.x * 1.5 + (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x) * 2 - 3
  
  Results = rbind(Results, Prediction2)
  
}
##########
##########
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


write.csv(NewResults, file = "Results_Dec_NCAA.csv")
write.csv(NewResults, file = "Results_Dec_NCAA_Today.csv")

