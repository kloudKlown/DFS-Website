using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    public class NBAPlayerStats : NBAPlayers
    {

        public NBAPlayerStats() : 
            base()
        {
            Team = new NBATeam();
            Opposition = new NBATeam();
        }

        public DateTime GameDate { get; set; }

        public NBATeam Team { get; set; }

        public NBATeam Opposition { get; set; }

        public bool Home { get; set; }

        public int WinLoss { get; set; }

        public int FieldGoal { get; set; }

        public TimeSpan MinutesPlayed { get; set; }

        public int FieldGoalAttempted { get; set; }

        public float FieldGoalPercentage { get; set; }

        public int ThreePointer { get; set; }

        public int ThreePointerAttempted { get; set; }

        public float ThreePointerPercentage { get; set; }

        public int FreeThrow { get; set; }

        public int FreeThrowAttempted { get; set; }

        public float FreeThrowPercentage { get; set; }

        public int OffensiveRebound { get; set; }

        public int DefensiveRebound { get; set; }

        public int TotalRebound { get; set; }

        public int Assits { get; set; }

        public int Steals { get; set; }

        public int Blocks { get; set; }

        public int TurnOvers { get; set; }

        public int PersonalFouls { get; set; }

        public int PointsScored { get; set; }

    }
}
