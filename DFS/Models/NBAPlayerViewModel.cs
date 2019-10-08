using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DFS.UI.Models
{
    public class NBAPlayerViewModel
    {
        public NBAPlayerViewModel()
        {
            PlayerList = new List<NBAPlayerViewModel>();
        }

        public NBAPlayerViewModel(NBAPlayers players): base()
        {
            Name = players.Name;
            Position = players.Position;
            Weight = players.Weight;
            Height = players.Height;
        }

        public string Name { get; set; }

        public string Position { get; set; }

        public int Weight { get; set; }

        public int Height { get; set; }

        public List<NBAPlayerViewModel> PlayerList { get; set; }
    }
}
