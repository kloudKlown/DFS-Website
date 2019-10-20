using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DFS.UI.Models
{
    [Serializable]
    public class NBAPlayerViewModel
    {

        public NBAPlayerViewModel()
        {

        }

        public NBAPlayerViewModel(NBAPlayerStats item)
        {
            Name = item.Name;
            Position = item.Position;
            Height = item.Height;
            Weight = item.Weight;
            GameDate = item.GameDate;
            Team = item.Team.Team;
            MinutesPlayed = item.MinutesPlayed;
            Usage = item.Usage;
            DefensiveRating = item.DefensiveRating;
            OffensiveRating = item.OffensiveRating;
            FieldGoal = item.FieldGoal;
            FieldGoalAttempted = item.FieldGoalAttempted;
            ThreePointer = item.ThreePointer;
            ThreePointerAttempted = item.ThreePointerAttempted;
            FreeThrow = item.FreeThrow;
            OffensiveRebound = item.OffensiveRebound;
            DefensiveRebound = item.DefensiveRebound;
            TotalRebound = item.TotalRebound;
            TotalReboundPercentage = item.TotalReboundPercentage;
            Assists = item.Assists;
            Steals = item.Steals;
            Blocks = item.Blocks;
            Turnovers = item.Turnovers;
            Points = item.Points;
            Fouls = item.Fouls;
        }
        
        public string Team { get; set; }

        public string Position { get; set; }

        public string MultiPosition { get; set; }

        public string Name { get; set; }

        public int Weight { get; set; }

        public int Height { get; set; }

        public DateTime GameDate { get; set; }

        public TimeSpan MinutesPlayed { get; set; }

        public double FieldGoal { get; set; }

        public double FieldGoalAttempted { get; set; }

        public double Usage { get; set; }

        public double ThreePointer { get; set; }

        public double ThreePointerAttempted { get; set; }

        public double DefensiveRating { get; set; }

        public double FreeThrow { get; set; }

        public double TotalReboundPercentage { get; set; }

        public double OffensiveRating { get; set; }

        public double OffensiveRebound { get; set; }

        public double DefensiveRebound { get; set; }

        public double TotalRebound { get; set; }

        public double Assists { get; set; }

        public double Steals { get; set; }

        public double Blocks { get; set; }

        public double Turnovers { get; set; }

        public double Fouls { get; set; }
        
        public double Points { get; set; }
    }

    public static class NBAPlayerViewModelExtend
    {
        public static NBAPlayerViewModel SetMultiPosition(this NBAPlayerViewModel models, string position)
        {
            models.MultiPosition = position;
            return models;
        }
    }
}
