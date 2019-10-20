using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    [Serializable]
    public class NBATeam
    {
        public NBATeam()
        {
            
        }

        
        public NBATeam(string team)
        {
            Team = team;
        }
        
        public string Team { get; set; }
    }
}
