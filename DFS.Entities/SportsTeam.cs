using System;

namespace DFS.Entities
{
    [Serializable]
    public class SportsTeam
    {
        public SportsTeam()
        {
            
        }

        
        public SportsTeam(string team)
        {
            Team = team;
        }
        
        public string Team { get; set; }
    }
}
