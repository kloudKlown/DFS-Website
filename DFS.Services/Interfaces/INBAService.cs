using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Services.Interfaces
{
    public interface INBAService
    {
        //List<NBAPlayers> GetAllPlayers();

        List<NBATeamPlayers> GetPlayersByDateAndTeam(DateTime gameDate, string teamName, string oppositionName);

        //List<NBAPlayerStats> GetPlayerStatsHistorical(DateTime gameDate, int daysBefore);

        List<NBAGames> GetNBAGames(DateTime date);

        List<NBAPlayerStats> GetGameStatsByDate(DateTime Date, string TeamName, string OppositionName);

        List<NBAPlayerZoneStats> GetPlayerZoneStats(string PlayerName);

        List<NBAPlayerZoneStats> GetTeamZoneStats(string Team);

        List<NBAPlayerZoneStats> GetTopScorerShotChart(string Team);

        bool PlayerSelected(DateTime Date, string Name, string Team);

    }

}
