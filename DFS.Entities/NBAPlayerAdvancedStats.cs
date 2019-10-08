using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    public class NBAPlayerAdvancedStats : NBAPlayers
    {
        public NBAPlayerAdvancedStats() : base()
        {
            Team = new NBATeam();
            Opposition = new NBATeam();
        }

        public NBATeam Team { get; set; }

        public NBATeam Opposition { get; set; }

        public bool Home { get; set; }

        public float TrueShootingPercentage { get; set; }

        public float EffectiveFieldGoalPercentage { get; set; }

        public float OffensiveReboundPercentage { get; set; }

        public float DefensiveReboundPercentage { get; set; }

        public float TrueReboundPercentage { get; set; }

        public float AssitsPercentage { get; set; }

        public float StealsPercentage { get; set; }

        public float BlockPercentage { get; set; }

        public float TurnOverPercentage { get; set; }

        public float UsagePercentage { get; set; }

        public int  OffensiveRating { get; set; }

        public int DefensiveRating { get; set; }
    }

}
