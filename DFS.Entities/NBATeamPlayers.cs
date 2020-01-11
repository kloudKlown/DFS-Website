using System;

namespace DFS.Entities
{
    [Serializable]
    public class NBATeamPlayers
    {

        public NBATeamPlayers()
        {
            Player = new Player();
            Team = new SportsTeam();
        }

       public NBATeamPlayers(string name, string position, int height, int weight, string team, DateTime gameDate)
        {
            Player = new Player(name, position, height, weight);
            Team = new SportsTeam(team);
            GameDate = gameDate;
        }

        public Player Player { get; set; }

        public SportsTeam Team { get; set; }  

        public DateTime GameDate { get; set; }

        public decimal Predicted { get; set; }

        public string Salary { get; set; }

        public decimal SalaryDifference { get; set; }

        public decimal Actual { get; set; }

    }
}
