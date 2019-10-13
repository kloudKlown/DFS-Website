using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DFS.UI.Common
{
    public class AllControllers : Controllers
    {
        private AllControllers(string value):
            base(value)
        {

        }

        public static readonly Controllers Home = new AllControllers("Home");
        public static readonly Controllers NBA = new AllControllers("NBA");
    }
}
