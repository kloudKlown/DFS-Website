using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    [Serializable]

    public class NBAGames : NBATeam
    {
        public NBAGames() : base()
        {

        }

        public NBATeam HomeTeam { get; set; }

        public NBATeam AwayTeam { get; set; }

    }
}
