using System;

namespace DFS.Entities
{
    [Serializable]
    public class NCAATeamPlayers
    {

        public NCAATeamPlayers()
        {
            Player = new Player();
            Team = new SportsTeam();
        }

       public NCAATeamPlayers(string name, string position, int height, int weight, string team, DateTime gameDate)
        {
            Player = new Player(name, position, height, weight);
            Team = new SportsTeam(team);
            GameDate = gameDate;
        }

        public Player Player { get; set; }

        public SportsTeam Team { get; set; }  

        public DateTime GameDate { get; set; }

        public double Predicted { get; set; }

        public double MinutesPlayed { get; set; }

        public double Assists { get; set; }

        public double Rebounds { get; set; }

        public SportsTeam Opposition { get; set; }

        public double AveragePointsAllowed { get; set; }

        public double SimpleProjection { get; set; }

        public double AveragePointsScored { get; set; }

        public double Line { get; set; }

        public double OU { get; set; }

        public string FV { get; set; }
        
        public double TotalTeamScore { get; set; }

        public double OpposingTeamScore { get; set; }

        public double Total { get; set; }

    }
}
