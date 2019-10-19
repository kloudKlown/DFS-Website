﻿namespace DFS.UI.Controllers
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

            return Json(new { activePlayerList = nbaGamesActivePlayers, inactivePlayersList = nbaGamesinActivePlayers });
        }

        #region Private Helpers

        private (List<NBAPlayerViewModel> active, List<NBAPlayerViewModel> inactive) MinuteBalancer(List<NBAPlayerViewModel> playerViewModel, List<NBATeamPlayers> playerList)
        {
            List<NBAPlayerViewModel> inactiveList = new List<NBAPlayerViewModel>();
            List<NBAPlayerViewModel> activeList = new List<NBAPlayerViewModel>();

            inactiveList.AddRange(from NBAPlayerViewModel player in playerViewModel
                                  where !playerList.Any(x => x.Player.Name == player.Name && x.Team.Name == player.Team)
                                  select player);

            activeList.AddRange(from NBAPlayerViewModel player in playerViewModel
                                where playerList.Any(x => x.Player.Name == player.Name && x.Team.Name == player.Team)
                                select player.SetMultiPosition(playerList.Find(x => x.Player.Name == player.Name && x.Team.Name == player.Team).Player.Position));

            return (active: activeList, inactive: inactiveList);
        }

        #endregion

    }
}