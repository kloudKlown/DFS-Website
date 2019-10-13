namespace DFS.UI.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DFS.Services.Interfaces;
    using DFS.UI.Models;
    using Microsoft.AspNetCore.Mvc;
    using Newtonsoft.Json;
    using DFS.Common;

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
        public IActionResult GetGamesForDate(DateTime date)
        {
            List<NBAGamesViewModel> nbaGames = new List<NBAGamesViewModel>();

            if (date < Extensions.DateExtensions.DateTimeMinAllowed)
            {
                return Json(new { });
            }

            var result = NBAService.GetNBAGames(date);

            if (result != null && result.Count > 0)
            {
                foreach (var item in result)
                {
                    nbaGames.Add(new NBAGamesViewModel(item));
                }
            }

            return Json(JsonConvert.SerializeObject(nbaGames));
        }
    }
}