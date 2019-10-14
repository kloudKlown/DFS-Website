﻿using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Services.Interfaces
{
    public interface INBAService
    {
        List<NBAPlayers> GetAllPlayers();

        List<NBATeamPlayers> GetNBATeamPlayersForDate(DateTime gameDate);

        List<NBAPlayerStats> GetPlayerStatsHistorical(DateTime gameDate, int daysBefore);

        List<NBAGames> GetNBAGames(DateTime date);

        List<NBAPlayerStats> GetGameStatsByDate(DateTime date, string teamName, string oppositionName);

    }

}
