using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Data.Managers.Interfaces
{
    public interface INBAManager
    {
        IEnumerable<NBAPlayers> GetAllPlayers();

        IEnumerable<NBATeam> GetAllNBATeams();
        
    }
}
