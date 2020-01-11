using System;
using DFS.Common;

namespace DFS.Entities
{
    [Serializable]

    public class Player
    {
        public Player()
        {            

        }

        public Player(string name, string position, int height, int weight): base()
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
