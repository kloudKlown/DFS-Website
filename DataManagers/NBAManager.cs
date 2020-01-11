using Dapper;
using DFS.Data.Managers.Interfaces;
using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using static Dapper.SqlMapper;

namespace DFS.Data.Managers
{
    public class NBAManager : BaseManagers, INBAManager
    {
        private readonly string NBADatabase = DFS.Common.Constants.DataBase.NBA;

        public IEnumerable<SportsTeam> GetAllNBATeams()
        {
            throw new NotImplementedException();
        }

        public IEnumerable<Player> GetAllPlayers()
        {
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                return connection.Query<Player>("usp_GetAllPlayers", commandType: CommandType.StoredProcedure);
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
                        HomeTeam = new SportsTeam(item.HomeTeam),
                        AwayTeam = new SportsTeam(item.AwayTeam),
                        OverUnder = item.OverUnder,
                        Line = item.Line,
                        Favourite = item.Favourite
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
                        date_ = date.Date,
                        teamName_ = team,
                        oppName_ = opp
                    },
                    commandType: CommandType.StoredProcedure);

                foreach (var item in queryResult)
                {
                    result.Add(MapNBASelectedTeamPlayers(item));
                }
                
                return result;
            }
        }


        public IEnumerable<NBAPlayerStats> GetGameStatsByDate(DateTime date, string teamName, string oppositionName)
        {
            List<NBAPlayerStats> result = new List<NBAPlayerStats>();
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                GridReader queryResult;

                if (date.Date < DateTime.Now.Date.AddDays(-2))
                {
                    queryResult = connection.QueryMultiple("usp_GetTeamStatsByDate",
                        new
                        {
                            date_ = date,
                            teamName_ = teamName,
                            oppName_ = oppositionName
                        },
                        commandType: CommandType.StoredProcedure);
                }
                else
                {
                    queryResult = connection.QueryMultiple("usp_GetTeamStatsCurrent",
                        new
                        {
                            date_ = date,
                            teamName_ = teamName,
                            oppName_ = oppositionName
                        },
                        commandType: CommandType.StoredProcedure);

                }

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


        public IEnumerable<NBAPlayerZoneStats> GetPlayerZoneStats(string player)
        {
            List<NBAPlayerZoneStats> result = new List<NBAPlayerZoneStats>();
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                var queryResult = connection.Query("usp_GetZoneStats_Player",
                        new
                        {
                            @player_ = player
                        },
                        commandType: CommandType.StoredProcedure);

        
                // Result Set Team
                foreach (var item in queryResult)
                {
                    result.Add(MapNBAPlayerZoneStats(item));
                }

                return result;
            }
        }


        public IEnumerable<NBAPlayerZoneStats> GetTeamZoneStats(string player)
        {
            List<NBAPlayerZoneStats> result = new List<NBAPlayerZoneStats>();
            using (IDbConnection connection = GetConnection(NBADatabase))
            {
                var queryResult = connection.Query("usp_GetZoneStats_Team",
                        new
                        {
                            @team_ = player
                        },
                        commandType: CommandType.StoredProcedure);


                // Result Set Team
                foreach (var item in queryResult)
                {
                    result.Add(MapNBAPlayerZoneStats(item));
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
                Team = new SportsTeam(item.Team),
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
        
        private NBAPlayerZoneStats MapNBAPlayerZoneStats(dynamic item)
        {
            return new NBAPlayerZoneStats
            {
                playerName = item.PlayerName,
                GameDate = item.GameDate,
                Opp = new SportsTeam(item.Opp),
                Team = new SportsTeam(item.Team),
                Totals = item.Totals,
                FreeThrows = item.FreeThrows,
                Zones = item.Zones,
                Shot = item.Shot
            };
        }

        private NBATeamPlayers MapNBASelectedTeamPlayers(dynamic item)
        {
            return new NBATeamPlayers
            {
                Player = new Player(item.Name, item.Position, item.Height, item.Weight),
                GameDate = item.GameDate,
                Team = new SportsTeam(item.Team),
                Predicted = item.Predicted,
                Salary = item.ActualSalary,
                SalaryDifference = item.SalaryDiff,
                Actual = item.Actual
            };
        }
        #endregion
    }
}
