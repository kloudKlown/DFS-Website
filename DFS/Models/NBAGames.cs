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
            OverUnder = games.OverUnder;
            Line = games.Line;
            Favourite = games.Favourite;
        }

        public string HomeTeam { get; set; }

        public string AwayTeam { get; set; }

        public double OverUnder { get; set; }

        public double Line { get; set; }

        public string Favourite { get; set; }
    }
}
