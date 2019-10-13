using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    public class NBAGames : NBATeam
    {
        public NBAGames() : base()
        {

        }

        public NBATeam HomeTeam { get; set; }

        public NBATeam AwayTeam { get; set; }

    }
}
