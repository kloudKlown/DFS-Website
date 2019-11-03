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

        IEnumerable<NBATeamPlayers> GetPlayersByDateAndTeam(DateTime date, string team, string opp);

        IEnumerable<NBAPlayerStats> GetPlayerStatsHistorical(DateTime date, int daysBefore);

        IEnumerable<NBAPlayerAdvancedStats> GetPlayerAdvancedStatsHistorical(DateTime date, int daysBefore);

        IEnumerable<NBAGames> GetNBAGames(DateTime date);

        IEnumerable<NBAPlayerStats> GetGameStatsByDate(DateTime date, string teamName, string oppositionName);

        IEnumerable<NBAPlayerZoneStats> GetPlayerZoneStats(string player);

        IEnumerable<NBAPlayerZoneStats> GetPlayerZoneStats(string team);

    }
}
