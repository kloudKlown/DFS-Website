using DFS.Data.Managers;
using DFS.Data.Managers.Interfaces;
using DFS.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DFS.Services
{
    public class NCAAService : Interfaces.INCAAService
    {
        protected INCAAManager NCAAManager { get; private set; }

        public NCAAService()
        {
            NCAAManager = new NCAAManager();
        }

        public IEnumerable<NCAATeamPlayers> GetNCAAPlayersPrediction(DateTime date)
        {
            try
            {
                return NCAAManager.GetNCAAPlayersPrediction(date).Select(x => x).ToList();
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}
