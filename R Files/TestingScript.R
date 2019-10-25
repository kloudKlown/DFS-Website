library(stringdist)
###### Clean and Analyse BureauData
AllNBAData = read.csv(file = "TableData.csv", header = TRUE)
colnames(AllNBAData)[colnames(AllNBAData)=="ï..Date"] <- "Date"
AllNBAData$PlayerName = gsub("(?=[A-Z])", " ", AllNBAData$PlayerName , perl = TRUE)
AllNBAData$PlayerName = gsub("^\\s", "", AllNBAData$PlayerName , perl = TRUE)
AllNBAData[AllNBAData == "NULL"] = 0
AllNBAData$Date = as.Date(AllNBAData$Date)

# colnames(AllNBAData)[colnames(AllNBAData)=="oneGS"] <- "Team"
AllNBAData$PlayerActualTeamsition = toupper(AllNBAData$PlayerActualTeamsition)
AllNBAData$PlayerActualTeamsition = gsub("/[A-Z]*", "", (AllNBAData$PlayerActualTeamsition) , perl = TRUE)


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
  
  for (i in 1:16) {
    index = which.min(distances[i,])
    if (PlayerActualTeamsSubset[i,]$V3 == "Q" | grepl("INJ",PlayerActualTeamsSubset[i,]$V3) |
        grepl("OUT",PlayerActualTeamsSubset[i,]$V3) | grepl("D",PlayerActualTeamsSubset[i,]$V3) ){
      print('shit')
      next()
    } 
    ### For the last 15 days set the new team as older team
    AllNBAData[as.character(AllNBAData$PlayerName) == as.character(PlayerActualPosSubset[index])
               & as.Date(AllNBAData$Date) > (as.Date(TodayDate) - 15)
               ,c("Tm")] = PlayerActualTeamsSubset[i,]$V1
    print(i)
  }
}

