using DFS.Data.Managers;
using DFS.Data.Managers.Interfaces;
using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

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
    }
}
