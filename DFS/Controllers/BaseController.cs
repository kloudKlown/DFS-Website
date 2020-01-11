namespace DFS.UI.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DFS.Services.Interfaces;
    using DFS.UI.Common.Helpers;
    using Microsoft.AspNetCore.Http;   
    using Microsoft.AspNetCore.Mvc;

    public class BaseController : Controller
    {
        protected INBAService NBAService { get; private set; }

        protected INCAAService NCAAService { get; private set; }

        protected ISession Session => HttpContext.Session;

        public BaseController(INBAService nBA)
        {
            NBAService = nBA;
        }
        
        public BaseController(INCAAService ncaa)
        {
            NCAAService = ncaa;
        }


    }
}