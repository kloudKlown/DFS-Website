using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    public class NBATeamPlayers
    {
        public NBATeamPlayers()
        {
            Player = new NBAPlayers();
            Team = new NBATeam();
        }

        public NBAPlayers Player { get; set; }

        public NBATeam Team { get; set; }  

    }
}
