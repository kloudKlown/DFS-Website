using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DFS.Services.Interfaces;
using DFS.UI.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace DFS.UI.Controllers
{
    public class NBAController : BaseController
    {
        public NBAController(INBAService nBA) : base(nBA)
        {

        }

        public IActionResult Index()
        {
            return View();
        }


        [HttpPost]
        public IActionResult GetGameResults(DateTime date, int daysBefore)
        {
            NBAPlayerViewModel model = new NBAPlayerViewModel();
            var test = NBAService.GetPlayerStatsHistorical(new DateTime(2018, 12, 1), 10);
            return Json(JsonConvert.SerializeObject(test));
        }
    }
}