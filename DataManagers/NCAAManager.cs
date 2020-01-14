using Dapper;
using DFS.Data.Managers.Interfaces;
using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace DFS.Data.Managers
{
    public class NCAAManager : BaseManagers, INCAAManager
    {
        private readonly string NCAADatabase = DFS.Common.Constants.DataBase.NBA;

        public IEnumerable<NCAATeamPlayers> GetNCAAPlayersPrediction(DateTime date)
        {
            List<NCAATeamPlayers> result = new List<NCAATeamPlayers>();
            using (IDbConnection connection = GetConnection(NCAADatabase))
            {
                var query = connection.Query<dynamic>("usp_GetNCAAPrediction",
                    new
                    {
                        date_ = date
                    }, commandType: CommandType.StoredProcedure);

                foreach (var item in query)
                {
                    result.Add(MapNCAASelectedTeamPlayers(item));
                }
                
            }

            return result;
        }

        private NCAATeamPlayers MapNCAASelectedTeamPlayers(dynamic item)
        {
            return new NCAATeamPlayers()
            {
                Player = new Player(item.Player, item.Position, item.Height, item.Weight),
                Team = new SportsTeam(item.Team),
                Opposition = new SportsTeam(item.Opp),
                Predicted = item.RFPred,
                MinutesPlayed = item.MP,
                Assists = item.assists,          
                Total = item.Total,
                TotalTeamScore = item.TotalTeamScore,
                AveragePointsAllowed = item.AveragePointsAllowed,
                AveragePointsScored = item.AveragePointsScored,
                Line = item.Line == null ? 0 : item.Line,
                OU = item.OU == null ? 0 : item.OU,
                FV = item.FV == null ? "0" : item.FV,
                OpposingTeamScore = item.OpposingTeamScore,
                SimpleProjection = item.SimpleProjection
            };
        }
    }
}
