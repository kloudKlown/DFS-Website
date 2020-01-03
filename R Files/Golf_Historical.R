setwd("C:/Users/suhas/Source/Repos/kloudKlown/DFS-Website/R Files")
source('RIncludes.R')
source('Golf_getDBData.R')



# 
PreviousTournamentID = 401025260
PreviousPlayers = GolfPlayerTourStats[GolfPlayerTourStats$TournamentID == PreviousTournamentID, ]$PlayerID
PreviousPlayerTourStats = GolfPlayerTourStats[GolfPlayerTourStats$PlayerID %in% PreviousPlayers
                                              & GolfPlayerTourStats$TournamentID == PreviousTournamentID, ]

PreviousPlayerLogs = GolfPlayerLogs[GolfPlayerLogs$PlayerID %in% PreviousPlayers
                                    & GolfPlayerLogs$TournamentID == PreviousTournamentID, ]

## Scorecard
PreviousTotals = aggregate(PreviousPlayerLogs, by = list(PreviousPlayerLogs$PlayerID), FUN = sum)
PreviousTotals$PlayerID = PreviousTotals$Group.1
PreviousTotals = merge(PreviousTotals, GolfPlayer, by = c("PlayerID"))
PreviousTotals = subset(PreviousTotals, PreviousTotals$Scorecard > 160)
PreviousTotals = PreviousTotals[order(PreviousTotals$Scorecard, decreasing = FALSE), ]

## Top 10 players
TopTen = PreviousTotals$PlayerID[1:20]
PreviousPlayerLogs = GolfPlayerLogs[GolfPlayerLogs$PlayerID %in% TopTen
                                    & GolfPlayerLogs$TournamentID == PreviousTournamentID, ]
PreviousPlayerTourStats = GolfPlayerTourStats[GolfPlayerTourStats$PlayerID %in% TopTen
                                              & GolfPlayerTourStats$TournamentID == PreviousTournamentID, ]

PreviousPlayerTourStats = merge(PreviousPlayerTourStats, PreviousTotals, 
                                by = c("PlayerID"))
PreviousPlayerTourStats = PreviousPlayerTourStats[order(PreviousPlayerTourStats$Scorecard, 
                                                        decreasing = FALSE), ]

### Test 1
TournamentID  = 401056555
nrow(GolfPlayerTourStats[GolfPlayerTourStats$TournamentID == TournamentID,])
Players = GolfPlayerTourStats[GolfPlayerTourStats$TournamentID == TournamentID,]$PlayerID
Players == 3470
PlayerDataSet = GolfPlayerLogs[GolfPlayerLogs$PlayerID %in% Players 
                               &GolfPlayerLogs$TournamentID < TournamentID , ]

PlayerMC = aggregate(PlayerDataSet, by = list(PlayerDataSet$PlayerID,PlayerDataSet$TournamentID), FUN = sum)
PlayerMC = subset(PlayerMC, PlayerMC$Scorecard > 160)
PlayerMC$PlayerID = PlayerMC$Group.1
PlayerMC$TournamentID = PlayerMC$Group.2

PlayerTourStats = GolfPlayerTourStats[GolfPlayerTourStats$PlayerID %in% Players 
                                 & GolfPlayerTourStats$TournamentID %in% PlayerMC$TournamentID, ]
PlayerTourStats = subset(PlayerTourStats, PlayerTourStats$Years >= 2018)

averagePlayerTourStats = aggregate(PlayerTourStats, by = list(PlayerTourStats$PlayerID), FUN= mean)

averagePlayerTourStats = averagePlayerTourStats[(averagePlayerTourStats$AvgDRV > 290 &
                                                   averagePlayerTourStats$FWY > 60 &
                                                   averagePlayerTourStats$GIR > 60 &
                                                   averagePlayerTourStats$GIT > 1.65
                                                   )
                                                ,]
temp = merge(averagePlayerTourStats, GolfPlayer, 
      by = c("PlayerID"))
temp[order(temp$FWY),]
summary(PreviousPlayerTourStats)

