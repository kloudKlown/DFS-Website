﻿using DFS.Data.Managers;
using DFS.Data.Managers.Interfaces;
using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DFS.Common;

namespace DFS.Services.Interfaces
{
    public class NBAService : INBAService
    {
        protected INBAManager NBAManager { get; private set; }

        public NBAService()
        {
            NBAManager = new NBAManager();
        }

        public List<NBAPlayers> GetAllPlayers()
        {
            try
            {
                return NBAManager.GetAllPlayers().Select(x => x).ToList();
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public List<NBATeamPlayers> GetNBATeamPlayersForDate(DateTime gameDate)
        {
            try
            {
                return NBAManager.GetTeamPlayersByDate(gameDate).Select(x => x).ToList();
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public List<NBAPlayerStats> GetPlayerStatsHistorical(DateTime gameDate, int daysBefore)
        {
            try
            {
                return NBAManager.GetPlayerStatsHistorical(gameDate, daysBefore).Select(x => x).ToList();
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public List<NBAGames> GetNBAGames(DateTime date)
        {
            try
            {
                if (date > Extensions.DateExtensions.DateTimeMinAllowed)
                {
                    return NBAManager.GetNBAGames(date).Select(x => x).ToList();
                }
                else
                {
                    return new List<NBAGames>();
                }
                
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}
