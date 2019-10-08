using System;
using DFS.Common;

namespace DFS.Entities
{
    public class NBAPlayers
    {
        public NBAPlayers()
        {            
        }

        public NBAPlayers(string name, NBATeam team, int height, string position, int weight): base()
        {
            Name = name;            
            Height = height;        
            Position = position;
            Weight = weight;
        }

        public string Name { get; set; }
        
        public int Height { get; set; }

        public string Position { get; set; }

        public int Weight { get; set; }

    }
}
