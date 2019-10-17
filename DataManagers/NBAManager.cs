﻿using Dapper;
using DFS.Data.Managers.Interfaces;
using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DFS.Data.Managers
{
    public class NBAManager : BaseManagers, INBAManager
    {
        private readonly string NBADatabase = DFS.Common.Constants.DataBase.NBA;

        public IEnumerable<NBATeam> GetAllNBATeams()
        {
            throw new NotImplementedException();
        }

        public IEnumerable<NBAPlayers> GetAllPlayers()
        {
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                return connection.Query<NBAPlayers>("usp_GetAllPlayers", commandType: CommandType.StoredProcedure);
            }
        }
        
        public IEnumerable<NBAGames> GetNBAGames(DateTime date)
        {
            List<NBAGames> games = new List<NBAGames>();
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                var query = connection.Query<dynamic>("usp_GetGamesForDate",
                    new
                    {
                        date_ = date
                    }, commandType: CommandType.StoredProcedure);

                foreach (var item in query)
                {
                    games.Add(new NBAGames
                    {
                        HomeTeam = new NBATeam(item.HomeTeam),
                        AwayTeam = new NBATeam(item.AwayTeam)
                    });
                }
            }
            return games;
        }

        public IEnumerable<NBAPlayerAdvancedStats> GetPlayerAdvancedStatsHistorical(DateTime date, int daysBefore)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<NBAPlayerStats> GetPlayerStatsHistorical(DateTime date, int daysBefore)
        {
            List<NBAPlayerStats> result = new List<NBAPlayerStats>();

            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                var queryResult = connection.Query<dynamic>("usp_GetPlayersStatsHistoricalByDate",
                    new
                    {
                        gameDate_ = date,
                        daysBefore_ = daysBefore
                    },
                    commandType: CommandType.StoredProcedure);                
                return result;
            }
        }

        public IEnumerable<NBATeamPlayers> GetPlayersByDateAndTeam(DateTime date, string team, string opp)
        {
            List<NBATeamPlayers> result = new List<NBATeamPlayers>();
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                var queryResult = connection.Query("usp_GetPlayersForDate",
                    new
                    {                        
                        date_ = date,
                        teamName_ = team,
                        oppName_ = opp
                    },
                    commandType: CommandType.StoredProcedure);

                foreach (var item in queryResult)
                {
                    result.Add(new NBATeamPlayers(item.Name, item.Position, item.Height, item.Weight, item.Team, item.GameDate));
                }

                return result;
            }
        }


        public IEnumerable<NBAPlayerStats> GetGameStatsByDate(DateTime date, string teamName, string oppositionName)
        {
            List<NBAPlayerStats> result = new List<NBAPlayerStats>();
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                var queryResult = connection.QueryMultiple("usp_GetTeamStatsByDate",
                    new
                    {                        
                        date_ = date,
                        teamName_ = teamName,
                        oppName_ = oppositionName
                    },
                    commandType: CommandType.StoredProcedure);

                // Result Set Team
                foreach (var item in queryResult.Read<dynamic>())
                {
                    result.Add(MapNBAPLayerStats(item));
                }

                // Result Set Opposition
                foreach (var item in queryResult.Read<dynamic>())
                {
                    result.Add(MapNBAPLayerStats(item));
                }

                return result;
            }
        }

        #region Private Helpers

        private NBAPlayerStats MapNBAPLayerStats(dynamic item)
        {
            return new NBAPlayerStats
            {
                Name = item.PlayerName,
                Position = item.PlayerPosition,
                Height = item.Height,
                Weight = item.Weight,
                Team = new NBATeam(item.Team),
                MinutesPlayed = item.MinutesPlayed,
                Usage = item.Usage,
                DefensiveRating = item.DefRating,
                OffensiveRating = item.OffRating,
                FieldGoal = item.FieldGoals,
                FieldGoalAttempted = item.FieldGoalsAttempted,
                ThreePointer = item.ThreePointers,
                ThreePointerAttempted = item.ThreePointersAttempted,
                FreeThrow = item.FreeThrows,
                OffensiveRebound = item.DefRebounds,
                DefensiveRebound = item.OffRebounds,
                TotalRebound = item.TotalRebounds,
                TotalReboundPercentage = item.TotalReboundsPer,
                Assists = item.Assists,
                Steals = item.Steals,
                Blocks = item.Blocks,
                Turnovers = item.Turnover,
                Points = item.Points,
                Fouls = item.Fouls
            };
        }

        #endregion
    }
}
