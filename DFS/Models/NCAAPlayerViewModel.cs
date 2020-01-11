using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DFS.UI.Models
{
    public class NCAAPlayerViewModel
    {
        public NCAAPlayerViewModel()
        {

        }

        public NCAAPlayerViewModel(NCAATeamPlayers item)
        {
            Player = item.Player.Name;
            Opposition = item.Opposition.Team;
            Team = item.Team.Team;
            GameDate = item.GameDate;
            Predicted =  Math.Round(item.Predicted, 2);
            MinutesPlayed = new TimeSpan(0,0, (int)item.MinutesPlayed, 0 ) ;
            Assists = item.Assists;
            Rebounds = item.Rebounds;
            AveragePointsAllowed = item.AveragePointsAllowed;
            Line = item.Line;
            OU = item.OU;
            FV = item.FV;
            AveragePointsScored = item.AveragePointsScored;            
            TotalTeamScore = item.TotalTeamScore;
            OpposingTeamScore = item.OpposingTeamScore;
            Total = item.Total;

        }

        public string Player { get; set; }

        public string Opposition { get; set; }

        public string Team { get; set; }

        public DateTime GameDate { get; set; }

        public double Predicted { get; set; }

        public TimeSpan MinutesPlayed { get; set; }

        public double Assists { get; set; }

        public double Rebounds { get; set; }

        public double AveragePointsAllowed { get; set; }

        public double Line { get; set; }

        public double OU { get; set; }

        public string FV { get; set; }

        public double AveragePointsScored { get; set; }

        public double OwnThreeP { get; set; }

        public double TotalTeamScore { get; set; }

        public double OpposingTeamScore { get; set; }

        public double Total { get; set; }

        public double Actual { get; set; }
    }
}
