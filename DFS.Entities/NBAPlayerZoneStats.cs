namespace DFS.Entities
{
    using System;

    public class NBAPlayerZoneStats
    {
        public NBAPlayerZoneStats()
        {
            Team = new SportsTeam();
            Opp = new SportsTeam();
        }

        public DateTime GameDate { get; set; }

        public string playerName { get; set; }

        public SportsTeam Team { get; set; }

        public SportsTeam Opp { get; set; }

        public int Totals { get; set; }

        public int FreeThrows { get; set; }

        public string Zones { get; set; }

        public string Shot { get; set; } 

    }
}
