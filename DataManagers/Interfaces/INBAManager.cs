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

        IEnumerable<NBATeamPlayers> GetTeamPlayersByDate(DateTime date);

        IEnumerable<NBAPlayerStats> GetPlayerStatsHistorical(DateTime date, int daysBefore);

        IEnumerable<NBAPlayerAdvancedStats> GetPlayerAdvancedStatsHistorical(DateTime date, int daysBefore);

        IEnumerable<NBAGames> GetNBAGames(DateTime date);

    }
}
