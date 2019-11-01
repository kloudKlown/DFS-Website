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

        public decimal Predicted { get; set; }

        public string Salary { get; set; }

        public decimal SalaryDifference { get; set; }

        public decimal Actual { get; set; }
    }

    public static class NBAPlayerViewModelExtend
    {
        public static NBAPlayerViewModel SetMultiPosition(this NBAPlayerViewModel models, NBATeamPlayers player)
        {
            models.MultiPosition = player.Player.Position;
            models.Predicted = player.Predicted;
            models.Salary = player.Salary;
            models.SalaryDifference = player.SalaryDifference;
            models.Actual = player.Actual;
            return models;
        }
    }
}
