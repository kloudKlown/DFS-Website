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
            //var test = NBAService.GetPlayerStatsHistorical(new DateTime(2018,12, 1), 10);
            //model.PlayerList.AddRange(allPlayers.Select(x => new NBAPlayerViewModel(x)));

            return View(model);
        }

        [HttpPost]        
        public IActionResult GetGameResults(DateTime date, int daysBefore)
        {
            NBAPlayerViewModel model = new NBAPlayerViewModel();
            var test = NBAService.GetPlayerStatsHistorical(new DateTime(2018, 12, 1), 10);            
            return Json(JsonConvert.SerializeObject(test));
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
