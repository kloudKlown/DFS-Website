using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace DFS.Services.Interfaces
{
    public interface INCAAService
    {

        IEnumerable<NCAATeamPlayers> GetNCAAPlayersPrediction(DateTime date);

    }
}
