namespace DFS.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using DFS.Models;
    using DFS.Services;
    using DFS.Services.Interfaces;
    using DFS.Entities;
    using DFS.UI.Models;
    using Newtonsoft.Json;
    using DFS.UI.Controllers;

    public class HomeController : BaseController
    {
        public HomeController(INBAService nBA) : base(nBA)
        {
        }

        public IActionResult Index(NBAPlayerViewModel vm)
        {            
            NBAPlayerViewModel model = new NBAPlayerViewModel();
            RedirectToAction("/NBA/Index");
            return View(model);
        }
        
        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
