using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    [Serializable]

    public class NBAPlayerStats : Player
    {

        public NBAPlayerStats() : 
            base()
        {
            Team = new SportsTeam();
        }

        public DateTime GameDate { get; set; }

        public SportsTeam Team { get; set; }

        public bool Home { get; set; }        

        public TimeSpan MinutesPlayed { get; set; }

        public decimal FieldGoal { get; set; }        

        public decimal FieldGoalAttempted { get; set; }

        public decimal Usage { get; set; }

        public decimal ThreePointer { get; set; }

        public decimal ThreePointerAttempted { get; set; }

        public decimal DefensiveRating { get; set; }

        public decimal FreeThrow { get; set; }

        public decimal TotalReboundPercentage { get; set; }

        public decimal OffensiveRating { get; set; }

        public decimal OffensiveRebound { get; set; }

        public decimal DefensiveRebound { get; set; }

        public decimal TotalRebound { get; set; }

        public decimal Assists { get; set; }

        public decimal Steals { get; set; }

        public decimal Blocks { get; set; }

        public decimal Turnovers { get; set; }

        public decimal Fouls { get; set; }

        public decimal Points { get; set; }
    }
}
