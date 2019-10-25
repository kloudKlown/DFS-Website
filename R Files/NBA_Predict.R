setwd("D:/NBA")
source('RIncludes.R')

TodayDate = "2018-12-11"
game1 = c("HOU", "POR", "PHO", "SAS", "TOR", "LAC")
names(game1) = c("POR","HOU", "SAS", "PHO", "LAC", "TOR")

###setwd### Clean and Analyse BureauData
AllNBAData = read.csv(file = "TableData.csv", header = TRUE)
colnames(AllNBAData)[colnames(AllNBAData)=="ï..Date"] <- "Date"
AllNBAData$PlayerName = gsub("(?=[A-Z])", " ", AllNBAData$PlayerName , perl = TRUE)
AllNBAData$PlayerName = gsub("^\\s", "", AllNBAData$PlayerName , perl = TRUE)
AllNBAData[AllNBAData == "NULL"] = 0
AllNBAData$Date = as.Date(AllNBAData$Date)

# colnames(AllNBAData)[colnames(AllNBAData)=="oneGS"] <- "Team"
AllNBAData$PlayerPosition = toupper(AllNBAData$PlayerPosition)
AllNBAData$PlayerPosition = gsub("/[A-Z]*", "", (AllNBAData$PlayerPosition) , perl = TRUE)
Teams = unique(AllNBAData$Tm)

##############################################################################
##############################################################################
AllNBAData$PlayerPosition = toupper(AllNBAData$PlayerPosition)
AllNBAData$PlayerPosition = gsub("/[A-Z]*", "", (AllNBAData$PlayerPosition) , perl = TRUE)

### My list from DB
PlayerPos = read.csv(file = "PlayerPos.csv", header = TRUE)
colnames(PlayerPos)[colnames(PlayerPos)=="ï..PlayerName"] <- "PlayerName"
PlayerPos$PlayerName = gsub("(?=[A-Z])", " ", PlayerPos$PlayerName , perl = TRUE)
PlayerPos$PlayerName = gsub("^\\s", "", PlayerPos$PlayerName , perl = TRUE)
PlayerPos$Positions = ""

### From Fantasy Labs
PlayerActualPos = read.csv(file = "FLActualPositions.csv", header = FALSE)
teams = unique(PlayerActualPos$V1)

### Teams
for (t in teams) {
  PlayerPosSubset = subset(PlayerPos, as.character(PlayerPos$TM)  == as.character(t) )
  PlayerActualPosSubset = subset(PlayerActualPos, as.character(PlayerActualPos$V1)  == as.character(t) )
  
  distances = stringdistmatrix(PlayerActualPosSubset$V3, PlayerPosSubset$PlayerName)
  
  for (i in 1:5) {
    index = which.min(distances[i,])
    print(which.min(distances[i,]))
    
    AllNBAData[as.character(AllNBAData$PlayerName) == as.character(PlayerPosSubset[index,]$PlayerName)
               & as.character(AllNBAData$Tm) == as.character(PlayerPosSubset[index,]$TM)
               ,c("PlayerPosition")] = as.character(PlayerActualPosSubset[i,]$V2)
  }
}

##############################################################################
##############################################################################
# Assign teams to each player based on latest
PlayerActualTeams = read.csv(file = "PLayerList.csv", header = FALSE)
PlayerActualTeams$V2 = gsub("(?=[A-Z])", " ", PlayerActualTeams$V2 , perl = TRUE)
PlayerActualTeams$V2 = gsub("^\\s", "", PlayerActualTeams$V2 , perl = TRUE)
teams = unique(PlayerActualTeams$V1)

for (t in teams) {
  ### SubsetTeam
  PlayerActualTeamsSubset = subset(PlayerActualTeams, as.character(PlayerActualTeams$V1)  == as.character(t))
  ### Subset Team from all Data
  PlayerActualPosSubset = unique(AllNBAData$PlayerName)
  
  distances = stringdistmatrix(PlayerActualTeamsSubset$V2, PlayerActualPosSubset)
  
  for (i in 1:nrow(PlayerActualTeamsSubset)) {
    index = which.min(distances[i,])
    if (grepl("INJ",PlayerActualTeamsSubset[i,]$V3) |grepl("OUT",PlayerActualTeamsSubset[i,]$V3) 
        | grepl("D",PlayerActualTeamsSubset[i,]$V3) ){
      print('shit')
      AllNBAData[as.character(AllNBAData$PlayerName) == as.character(PlayerActualPosSubset[index])
                 ,c("PlayerName")] = paste(as.character(PlayerActualPosSubset[index]), "- Out")
      next()
    } 
    ### For the last 15 days set the new team as older team
    AllNBAData[as.character(AllNBAData$PlayerName) == as.character(PlayerActualPosSubset[index])
               & as.Date(AllNBAData$Date) > (as.Date(TodayDate) - 15)
               ,c("Tm")] = PlayerActualTeamsSubset[i,]$V1
    print(i)
  }
}

##############################################################################
###### Get 2017 data to check

All2017 = subset(AllNBAData, as.Date(AllNBAData$Date) > "2018-01-01" & as.Date(AllNBAData$Date) < "2018-12-01")
# View(All2017)

DateLevels = as.factor(unique(All2017[order(All2017$Date , decreasing = FALSE ),]$Date))
All2017[is.na(All2017)] = 0
All2017[is.null(All2017)] = 0
AllColumnNames = colnames(All2017)


# for (colname in 14:33){
#   print(AllColumnNames[colname])
#   All2017[,colname] = as.numeric(levels(All2017[,colname]))[All2017[,colname]]
# }

className = data.frame(sapply(All2017, class))
colNames = colnames(All2017)
All2017[is.na(All2017)] = 0
All2017[is.null(All2017)] = 0


# Defensive stats 3-15, 16-20
DefensiveStats = data.frame(matrix(ncol = 30))
colnames(DefensiveStats) = c("Tm","Pos" ,"Date","FG","FGA","FGper","ThreeP","ThreePA",
                             "ThreePper","FT","FTA","FTper","ORB","DRB",
                             "TRB","AST","STL","BLK","TOV","PF",
                             "GmSc","plusMinus", "FGAOpp", "ThreePAOpp",
                             "FTAOpp", "TRBOpp","ASTOpp","STLOpp","BLKOpp","TOVOpp")
DefensiveStats[is.na(DefensiveStats)] = 0

PositionsAll = unique( All2017$PlayerPosition )

### Get Defensive stats for each team
for (eachTeam in Teams) {
  # Iterate over each team
  subsetTeamData = subset(All2017, All2017$Tm == eachTeam)  
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
    print(date)
    print(length(DateLevels))
    
    for (pos in as.factor(PositionsAll) ){
      # Iterate over each date
      temp = DefensiveStats[1,]
      ## Make sure do not include this date but eveytyhing before.
      subsetTeamData = subset(All2017, All2017$Tm == eachTeam 
                              & as.Date(All2017$Date) < as.Date(DateLevels[date]) &
                                as.Date(All2017$Date) > (as.Date(DateLevels[date]) - 120) &
                                as.character(All2017$PlayerPosition) == pos )
      
      
      temp$Date = DateLevels[date]
      temp$Tm = eachTeam
      temp$Pos = pos
      #### How good the defense is
      for (column in 4:22){
        #print(colnames(temp)[column])
        temp[, colnames(temp)[column]]  = sum(subsetTeamData[, colnames(temp)[column]])
      }
      ## Make sure do not include this date but eveytyhing before.
      subsetOppData = subset(All2017, All2017$Tm %in% unique(subsetTeamData$Opp) 
                             & as.Date(All2017$Date) < as.Date(DateLevels[date]) 
                             & as.Date(All2017$Date) > (as.Date(DateLevels[date]) - 120)
                             & as.character(All2017$PlayerPosition) == pos 
      )
      
      #### How many points have been allowed
      for (column in 23:length(colnames(temp)) ){
        #print(colnames(temp)[column])
        col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
        
        temp[, colnames(temp)[column]]  = sum(subsetOppData[, col])
      }
      
      DefensiveStats = rbind(temp, DefensiveStats)
    }
    
  }
}


############################################################
##################################################
############################################################
############################################################
############################################################
############################################################

write.csv(DefensiveStats, file = "DefensiveStats_All.csv")


######### Offensive Stats
OffensiveStats = data.frame(matrix(ncol=26))
colnames(OffensiveStats) = c("PlayerName", "Tm", "PlayerPosition" , "Date", "Opp",  "TotalPoints", "MP",
                             "FG","FGA","FGper","ThreeP","ThreePA",
                             "ThreePper","FT","FTA","FTper","ORB","DRB",
                             "TRB","AST","STL","BLK","TOV","PF",
                             "GmSc","plusMinus")

All2017$TotalPoints = All2017$FT * 1 + (All2017$FG-All2017$ThreeP) * 2 + All2017$ThreeP * 3 + All2017$AST * 1.25 +
  (All2017$BLK + All2017$STL)* 2 + All2017$TRB * 1.5

allPlayers = unique(All2017$PlayerName)

for (player in allPlayers) {
  
  ## Get Playerdata
  subsetPlayerData = subset(All2017, All2017$PlayerName == player)  
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
    subsetPlayerData = subset(All2017, All2017$PlayerName == player 
                              & as.Date(All2017$Date) < as.Date(DateLevels[date]) 
                              & as.Date(All2017$Date) > (as.Date(DateLevels[date]) - 30)
    )  
    
    currentGame = subset(All2017, All2017$PlayerName == player 
                         & as.Date(All2017$Date) == as.Date(DateLevels[date]) 
    ) 
    
    if (nrow(currentGame) == 0 ){
      next
    }
    
    temp$Date = DateLevels[date]
    temp$PlayerName = player
    temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
    temp$Tm = as.character(subsetPlayerData$Tm[1])
    temp$Opp = as.character(currentGame$Opp[1])     
    temp$TotalPoints = currentGame$TotalPoints[1]
    #### How good the defense is
    for (column in 6:length(colnames(temp))){
      temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
    }
    
    OffensiveStats = rbind(temp, OffensiveStats)
  }
  ## Iterate over date
  
}

OffensiveStats[is.na(OffensiveStats)] = 0
OffensiveStats[is.null(OffensiveStats)] = 0

######### Offensive Stats
### Today's games
# OffensiveStats$Date = as.Date(OffensiveStats$Date)

OffensiveStats = subset(OffensiveStats, as.Date(OffensiveStats$Date) != as.Date(TodayDate))
DefensiveStats = subset(DefensiveStats, as.Date(DefensiveStats$Date) != as.Date(TodayDate))


### Get Defensive stats for each team
for (eachTeam in unique(All2017$Tm)) {
  # Iterate over each team
  subsetTeamData = subset(All2017, All2017$Tm == eachTeam)  
  if (nrow(subsetTeamData) == 0)
  {
    next;
  }
  print(eachTeam)
  ## Iterate over date
  print(TodayDate)
  
  for (pos in as.factor(PositionsAll) ){
    # Iterate over each date
    temp = DefensiveStats[1,]
    subsetTeamData = subset(All2017, All2017$Tm == eachTeam 
                            & as.Date(All2017$Date) < as.Date(TodayDate) &
                              as.Date(All2017$Date) > (as.Date(TodayDate) - 30)
                            & as.character(All2017$PlayerPosition) == pos 
    )  
    
    temp$Date = TodayDate
    temp$Tm = eachTeam
    temp$Pos = pos
    #### How good the defense is
    for (column in 4:22){
      temp[, colnames(temp)[column]]  = sum(subsetTeamData[, colnames(temp)[column]])
    }
    
    subsetOppData = subset(All2017, All2017$Tm %in% unique(subsetTeamData$Opp) 
                           & as.Date(All2017$Date) < as.Date(TodayDate) 
                           & as.Date(All2017$Date) > (as.Date(TodayDate) - 30) &
                             as.character(All2017$PlayerPosition) == pos 
    )
    
    #### How many points have been allowed
    for (column in 23:length(colnames(temp)) ){
      print(colnames(temp)[column])
      col = gsub('Opp', '',  colnames(temp)[column], perl = TRUE)
      
      temp[, colnames(temp)[column]]  = sum(subsetOppData[, col])
      
    }
    
    DefensiveStats = rbind(temp, DefensiveStats)
  }
  ## Iterate over date
}

allPlayers = unique(All2017$PlayerName)

### Get Offensive Stats for each player
for (player in allPlayers) {
  print(player)
  ## Get Playerdata
  subsetPlayerData = subset(All2017, All2017$PlayerName == player)  
  if (nrow(subsetPlayerData) == 0)
  {
    next;
  }
  
  DateLevels = as.factor(unique(subsetPlayerData[order(subsetPlayerData$Date , decreasing = FALSE ),]$Date))  
  # Add current Date
  
  ## Iterate over date
  # Iterate over each date
  temp = OffensiveStats[1,]
  subsetPlayerData = subset(All2017, All2017$PlayerName == player 
                            & as.Date(All2017$Date) < as.Date(TodayDate) 
                            & as.Date(All2017$Date) > (as.Date(TodayDate) - 30)
  )  
  
  if (nrow(subsetPlayerData) == 0){
    next
  }
  lastTeam = as.factor(unique(subsetPlayerData[order(subsetPlayerData$Date , decreasing = FALSE ),]$Tm))  
  
  temp$Opp = as.character(game1[ as.character(lastTeam[length(lastTeam)]) ])
  
  temp$Date = TodayDate
  temp$PlayerName = player
  temp$PlayerPosition = as.character(subsetPlayerData$PlayerPosition[1])
  temp$Tm = as.character(lastTeam[length(lastTeam)])
  temp$TotalPoints = 0
  #### How good the defense is
  for (column in 6:length(colnames(temp))){
    temp[, colnames(temp)[column]]  = mean(subsetPlayerData[, colnames(temp)[column]])
  }
  
  OffensiveStats = rbind(temp, OffensiveStats)
  ## Iterate over date
}

#Combine  Offensive and team defensive stats
# TodayDate = "2018-11-18"
CombinedStats = merge(OffensiveStats, DefensiveStats, by = c("Date"), by.x = c("Date", "Opp", "PlayerPosition"), by.y = c("Date", "Tm", "Pos" ) )
allPlayers = unique(CombinedStats$PlayerName)
DateCheck = TodayDate


Results = data.frame( RFPred = numeric(), player = factor(), position = factor(), salary = numeric(),
                      MP = numeric(), team = factor(), pointsScored = numeric() , assists = numeric(),
                      rebound = numeric(), pointsAllowedAgainstPosition = numeric(),
                      playerList = factor(), TeamScore = numeric(), Actual = numeric(),
                      simpleProjection = numeric(), Opp = numeric())


allPlayers = unique(subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck))$PlayerName)
##########
for (player in allPlayers){
  print(player)
  Data_Cleaned_Test = subset(CombinedStats, as.Date(CombinedStats$Date) == as.Date(DateCheck) 
                             & CombinedStats$PlayerName == as.character(player) )
  
  Data_Cleaned_Train = subset(CombinedStats, as.Date(CombinedStats$Date) < as.Date(DateCheck)
                              & as.Date(CombinedStats$Date) > (as.Date(DateCheck) - 365)
                              & CombinedStats$PlayerName == as.character(player) )
  
  if (nrow(Data_Cleaned_Train) == 0 | nrow(Data_Cleaned_Test) == 0){
    next;
  }
  # "FG.x",   "FGA.x",  "FGper.x","ThreeP.x",   "ThreePA.x", 
  # "ThreePper.x","FT.x",   "FTA.x",  "FTper.x",
  rf = randomForest( Data_Cleaned_Train[,c("MP", 
                                           "ORB.x", "TRB.x",  "AST.x",  "STL.x",  "BLK.x",  "TOV.x",  "PF.x",  
                                           "plusMinus.x","FG.y", "TRB.y","TOV.y"
  )], 
  y = Data_Cleaned_Train[,c("TotalPoints")], ntree=500
  ,type='regression')
  
  RFPred = predict( rf,  Data_Cleaned_Test[,c("MP",
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
  previousTeams = subset(All2017, All2017$Opp == as.character(Data_Cleaned_Test$Opp) 
                         & as.Date(All2017$Date) > (as.Date(DateCheck) - 60)
                         & as.Date(All2017$Date) < (as.Date(DateCheck))
                         & All2017$PlayerPosition == Data_Cleaned_Test$PlayerPosition
                         & All2017$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x) +
                                            Data_Cleaned_Test$AST.x * 1.25 + Data_Cleaned_Test$TRB.x * 1.5 + 2 * (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x)  - 1)
                         & All2017$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x)+
                                            Data_Cleaned_Test$AST.x * 1.25 + Data_Cleaned_Test$TRB.x * 1.5 + 2 * (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x) + 1)
  )
  i = 0
  
  while(nrow(previousTeams) < 4){
    i = i + 1
    # Get preivous teams against this position ( last 20 days )
    previousTeams = subset(All2017, All2017$Opp == as.character(Data_Cleaned_Test$Opp) 
                           & as.Date(All2017$Date) > (as.Date(DateCheck) - 60)
                           & as.Date(All2017$Date) < (as.Date(DateCheck))
                           & All2017$PlayerPosition == Data_Cleaned_Test$PlayerPosition
                           & All2017$PTS > (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x)+
                                              Data_Cleaned_Test$AST.x * 1.25 + Data_Cleaned_Test$TRB.x * 1.5 + 2 * (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x) - i*0.5)
                           & All2017$PTS < (Data_Cleaned_Test$FT.x + Data_Cleaned_Test$ThreeP.x*3 + 2*(Data_Cleaned_Test$FG.x - Data_Cleaned_Test$ThreeP.x)+
                                              Data_Cleaned_Test$AST.x * 1.25 + Data_Cleaned_Test$TRB.x * 1.5 + 2 * (Data_Cleaned_Test$STL.x + Data_Cleaned_Test$BLK.x) + i*0.5)
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
      previousTeamData = subset(All2017, 
                                as.Date(All2017$Date) == as.Date(datejk)
                                & All2017$Tm == tm
                                & All2017$PTS > previousTeams$PTS[jk] )
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
  
  Prediction2["simpleProjection"] = Prediction2$pointsAllowedAgainstPosition - 3
  
  Results = rbind(Results, Prediction2)
  
}
##########
##########
##########
##########
##########

teams = unique(Results$Team)

teamScoreVegas = data.frame(matrix(ncol=3))

for(t in 1:length(teams) ){
  ResTeam = subset(Results, Results$Team == teams[t])
  Results[Results$Team == teams[t],]$TeamScore = sum(ResTeam$RFPred)
  temp = data.frame(matrix(ncol=3))
  temp$X1 = teams[t]
  temp$X2 = ResTeam$TeamScore[1]
  temp$X3 = ResTeam$TeamScore[1]
  teamScoreVegas = rbind(teamScoreVegas, temp)
}


write.csv(Results, file = "Results_Dec_DK.csv")

