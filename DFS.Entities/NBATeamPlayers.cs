using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    [Serializable]
    public class NBATeamPlayers
    {

        public NBATeamPlayers()
        {
            Player = new NBAPlayers();
            Team = new NBATeam();
        }

       public NBATeamPlayers(string name, string position, int height, int weight, string team, DateTime gameDate)
        {
            Player = new NBAPlayers(name, position, height, weight);
            Team = new NBATeam(team);
            GameDate = gameDate;
        }

        public NBAPlayers Player { get; set; }

        public NBATeam Team { get; set; }  

        public DateTime GameDate { get; set; }

    }
}
