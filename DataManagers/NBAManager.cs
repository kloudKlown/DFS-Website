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

        #region Private Helpers
        
        #endregion
    }
}
