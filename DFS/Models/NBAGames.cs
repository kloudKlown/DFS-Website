using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DFS.UI.Models
{
    public class NBAGamesViewModel
    {
        public NBAGamesViewModel()
        {

        }

        public NBAGamesViewModel(NBAGames games)
        {
            HomeTeam = games.HomeTeam.Team;
            AwayTeam = games.AwayTeam.Team;
        }

        public string HomeTeam { get; set; }

        public string AwayTeam { get; set; }

    }
}
