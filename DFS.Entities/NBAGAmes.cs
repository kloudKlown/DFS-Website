using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    [Serializable]

    public class NBAGames : SportsTeam
    {
        public NBAGames() : base()
        {

        }

        public SportsTeam HomeTeam { get; set; }

        public SportsTeam AwayTeam { get; set; }

        public double OverUnder { get; set; }

        public double Line { get; set; }

        public string Favourite { get; set; }

    }
}
