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
    using DFS.Entities;
    using Microsoft.AspNetCore.Http;
    using DFS.UI.Common.Helpers;

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


        [HttpPost]
        public IActionResult GetGameStatsByDate(DateTime date, string team, string opp)
        {
            List<NBAPlayerViewModel> nbaGamesActivePlayers = new List<NBAPlayerViewModel>();
            List<NBAPlayerViewModel> nbaGamesinActivePlayers = new List<NBAPlayerViewModel>();

            if (date < Extensions.DateExtensions.DateTimeMinAllowed)
            {
                return Json(new { });
            }

            var result = NBAService.GetGameStatsByDate(date, team, opp);

            if (result != null && result.Count > 0)
            {
                foreach (var item in result)
                {
                    nbaGamesActivePlayers.Add(new NBAPlayerViewModel(item));
                }
            }

            List<NBATeamPlayers> playersResult = NBAService.GetPlayersByDateAndTeam(date, team, opp);

            // Balance the player minutes depending on game's lineup            
            var sortedPlayers = MinuteBalancer(nbaGamesActivePlayers, playersResult);
            nbaGamesActivePlayers = sortedPlayers.active;
            nbaGamesinActivePlayers = sortedPlayers.inactive;
            Session.SetObject("ActivePlayersList", nbaGamesActivePlayers);

            return Json(new { activePlayerList = nbaGamesActivePlayers, inactivePlayersList = nbaGamesinActivePlayers });
        }

        //[HttpPost]
        public IActionResult GetGridData(string sidx, string sord, int page, int rows, bool _search, string filters, string name, string team)
        {
            if (HttpContext.Session.GetString("ActivePlayersList") != null)
            {
                List<NBAPlayerViewModel> playerList = Session.GetObject<List<NBAPlayerViewModel>>("ActivePlayersList");

                if(sidx != null)
                {
                    if (sord == "asc")
                    {
                        playerList = playerList.OrderBy(x => x.GetType().GetProperty(sidx).GetValue(x, null)).ToList();
                    }
                    else
                    {
                        playerList = playerList.OrderByDescending(x => x.GetType().GetProperty(sidx).GetValue(x, null)).ToList();
                    }
                }

                if (!string.IsNullOrWhiteSpace(name))
                {
                    playerList = playerList.FindAll(x => x.Name.ToLower().Contains(name.ToLower())).ToList();
                }

                if (!string.IsNullOrWhiteSpace(team))
                {
                    playerList = playerList.FindAll(x => x.Team.ToLower().Contains(team.ToLower())).ToList();
                }

                return Json(new { data = playerList });
            }

            return Json(new { });
        }

        public IActionResult GetPlayerZones(string name)
        {
            var zones = NBAService.GetPlayerZoneStats(name);
            zones = zones.OrderByDescending(x => x.GameDate).Take(200).ToList();
            var groupedR = zones.GroupBy(x => x.Zones, x => x.Shot);

            var result = groupedR.Select(x => new {
                ShotType = x.Key,
                MadeShots = x.ToList().FindAll(v => v == "Made Shot").ToList().Count,
                TotalShots = x.ToList().Count,
                ZonePer = (x.ToList().FindAll(v => v == "Made Shot").ToList().Count * 100)  / (x.ToList().Count + 1)
            }).ToList();

            result = result.OrderByDescending(x => x.TotalShots).ToList();


            return Json(new { shotZone = JsonConvert.SerializeObject(result) });
        }

        #region Private Helpers

        private (List<NBAPlayerViewModel> active, List<NBAPlayerViewModel> inactive) MinuteBalancer(List<NBAPlayerViewModel> playerViewModel, List<NBATeamPlayers> playerList)
        {
            List<NBAPlayerViewModel> inactiveList = new List<NBAPlayerViewModel>();
            List<NBAPlayerViewModel> activeList = new List<NBAPlayerViewModel>();

            inactiveList.AddRange(from NBAPlayerViewModel player in playerViewModel
                                  where !playerList.Any(x => x.Player.Name == player.Name && x.Team.Team == player.Team)
                                  select player);

            activeList.AddRange(from NBAPlayerViewModel player in playerViewModel
                                where playerList.Any(x => x.Player.Name == player.Name && x.Team.Team == player.Team)
                                select player.SetMultiPosition(playerList.Find(x => x.Player.Name == player.Name && x.Team.Team == player.Team).Player.Position));

            return (active: activeList, inactive: inactiveList);
        }

        #endregion

    }
}