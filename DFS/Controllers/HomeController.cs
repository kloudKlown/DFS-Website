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

namespace DFS.Controllers
{
    public class HomeController : Controller
    {
        protected INBAService NBAService { get; private set; }

        public HomeController(INBAService nBA)
        {
            NBAService = nBA;
        }
        
        public IActionResult Index(NBAPlayerViewModel vm)
        {
            //List<NBAPlayers> allPlayers = NBAService.GetAllPlayers();            
            NBAPlayerViewModel model = new NBAPlayerViewModel();
            var test = NBAService.GetNBATeamPlayersForDate(new DateTime(2015, 1, 1));
            //model.PlayerList.AddRange(allPlayers.Select(x => new NBAPlayerViewModel(x)));

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
