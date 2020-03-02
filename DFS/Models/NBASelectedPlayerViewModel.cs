using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DFS.UI.Models
{
    public class NBASelectedPlayerViewModel : NBAPlayerViewModel
    {
        public NBASelectedPlayerViewModel()
        {

        }

        public NBASelectedPlayerViewModel(NBAPlayerStats item) : base(item)
        {

        }

        public int MinExposure { get; set; }

        public int MaxExposure { get; set; }

        public bool IsLocked { get; set; } 

    }
}
