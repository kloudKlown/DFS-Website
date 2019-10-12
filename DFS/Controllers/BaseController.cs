namespace DFS.UI.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DFS.Services.Interfaces;
    using Microsoft.AspNetCore.Mvc;

    public class BaseController : Controller
    {
        protected INBAService NBAService { get; private set; }

        public BaseController(INBAService nBA)
        {
            NBAService = nBA;
        }

    }
}