using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Data.Managers.Interfaces
{
    public interface INCAAManager
    {
        IEnumerable<NCAATeamPlayers> GetNCAAPlayersPrediction(DateTime date);
    }
}
