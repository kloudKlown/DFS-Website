using Dapper;
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

                foreach (var item in queryResult)
                {
                    result.Add(MapNBAPLayerStats(item));
                }

                return result;
            }
        }

        public IEnumerable<NBATeamPlayers> GetTeamPlayersByDate(DateTime date)
        {
            List<NBATeamPlayers> result = new List<NBATeamPlayers>();
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                var queryResult = connection.Query("usp_GetTeamPlayersByDate",
                    new
                    {
                        // TODO: Fix this with DBNull value instead
                        gameDate_ = date.Year < 2016 ? null : date.ToShortDateString()
                    },
                    commandType: CommandType.StoredProcedure);

                foreach (var item in queryResult)
                {
                    result.Add(new NBATeamPlayers(item.Name, item.Position, item.Height, item.Weight, item.Team, item.GameDate));
                }

                return result;
            }
        }



        #region Private Helpers

        private NBAPlayerStats MapNBAPLayerStats(dynamic item)
        {
            return new NBAPlayerStats
            {
                Name = item.Name,
                Position = item.Position,
                Height = item.Height,
                Weight = item.Weight,
                GameDate = item.GameDate,
                Team = new NBATeam(item.Team),
                Opposition = new NBATeam(item.Opposition),
                Home = item.Home == 1 ? true : false,
                WinLoss = item.WinLoss,
                MinutesPlayed = item.MinutesPlayed,
                FieldGoal = item.FieldGoal,
                FieldGoalAttempted = item.FieldGoalAttempted,
                FieldGoalPercentage = Math.Round(item.FieldGoalPercentage, 2),
                ThreePointer = item.ThreePointer,
                ThreePointerAttempted = item.ThreePointerAttempted,
                ThreePointerPercentage = Math.Round(item.ThreePointerPercentage, 2),
                FreeThrow = item.FreeThrow,
                FreeThrowAttempted = item.FreeThrowAttempted,
                FreeThrowPercentage = Math.Round(item.FreeThrowPercentage,2),
                OffensiveRebound = item.OffensiveRebound,
                DefensiveRebound = item.DefensiveRebound,
                TotalRebound = item.TotalRebound,
                Assists = item.Assists,
                Steals = item.Steals,
                Blocks = item.Blocks,
                TurnOvers = item.TurnOvers,
                PersonalFouls = item.PersonalFouls,
                PointsScored = item.PointsScored
            };
        }

        #endregion
    }
}
