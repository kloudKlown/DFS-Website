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

        public TimeSpan MinutesPlayed { get; set; }

        public double FieldGoal { get; set; }        

        public double FieldGoalAttempted { get; set; }

        public double FieldGoalPercentage { get; set; }

        public double ThreePointer { get; set; }

        public double ThreePointerAttempted { get; set; }

        public double ThreePointerPercentage { get; set; }

        public double FreeThrow { get; set; }

        public double FreeThrowAttempted { get; set; }

        public double FreeThrowPercentage { get; set; }

        public double OffensiveRebound { get; set; }

        public double DefensiveRebound { get; set; }

        public double TotalRebound { get; set; }

        public double Assists { get; set; }

        public double Steals { get; set; }

        public double Blocks { get; set; }

        public double TurnOvers { get; set; }

        public double PersonalFouls { get; set; }

        public double PointsScored { get; set; }

    }
}
