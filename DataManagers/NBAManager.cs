using Dapper;
using DFS.Data.Managers.Interfaces;
using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Data;
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

        #endregion
    }
}
