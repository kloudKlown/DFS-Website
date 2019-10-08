using System;
using DFS.Common;

namespace DFS.Entities
{
    public class NBAPlayers
    {
        public NBAPlayers()
        {            

        }

        public NBAPlayers(string name, string position, int height, int weight): base()
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
