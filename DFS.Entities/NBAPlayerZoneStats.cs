namespace DFS.Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.Text;


    public class NBAPlayerZoneStats
    {
        public NBAPlayerZoneStats()
        {
            Team = new NBATeam();
            Opp = new NBATeam();
        }

        public DateTime GameDate { get; set; }

        public string playerName { get; set; }

        public NBATeam Team { get; set; }

        public NBATeam Opp { get; set; }

        public int Totals { get; set; }

        public int FreeThrows { get; set; }

        public string Zones { get; set; }

        public string Shot { get; set; } 

    }
}
