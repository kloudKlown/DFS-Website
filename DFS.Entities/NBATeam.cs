using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Entities
{
    public class NBATeam
    {
        public NBATeam()
        {
            
        }
        public NBATeam(string name)
        {
            Name = name;
        }
        
        public string Name { get; set; }
    }
}
