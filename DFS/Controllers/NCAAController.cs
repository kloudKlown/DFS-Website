﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DFS.Entities;
using DFS.Services;
using DFS.Services.Interfaces;
using DFS.UI.Common.Helpers;
using DFS.UI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace DFS.UI.Controllers
{
    public class NCAAController : BaseController
    {
        public NCAAController(INCAAService ncaa) : base(ncaa)
        {

        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public IActionResult GetGamesForDate(DateTime date)
        {
            List<NCAAPlayerViewModel> players = new List<NCAAPlayerViewModel>();
            List<NCAAPlayerViewModel> playerTopMinutes = new List<NCAAPlayerViewModel>();
            Dictionary<string, List<NCAAPlayerViewModel>> dictPlayers = new Dictionary<string, List<NCAAPlayerViewModel>>();
            DateTime d = date.Date;
            var result = NCAAService.GetNCAAPlayersPrediction(d);
            result = result.OrderByDescending(x => x.MinutesPlayed);
            players = (from NCAATeamPlayers pla in result select new NCAAPlayerViewModel(pla)).ToList();

            foreach (NCAAPlayerViewModel item in players)
            {
                if (!dictPlayers.Keys.Contains(item.Team))
                {
                    dictPlayers[item.Team] = new List<NCAAPlayerViewModel>();
                }

                if(dictPlayers[item.Team].Count <= 7)
                {
                    dictPlayers[item.Team].Add(item);
                }
                else
                {
                    continue;
                }
            }

            foreach (var item in dictPlayers)
            {
                playerTopMinutes.AddRange(item.Value);
            }
            
            Session.SetObject("NCAAPrediction", players);

            var games = playerTopMinutes.GroupBy(x => x.Team).Select(x => new {
                HomeTeam = x.Key,
                TotalTeamScore = Math.Round(playerTopMinutes.First(y => y.Team == x.Key).TotalTeamScore, 2),
                OpposingTeamScore = Math.Round(playerTopMinutes.First(y => y.Team == x.Key).OpposingTeamScore, 2),
                AwayTeam = playerTopMinutes.First(y => y.Team == x.Key).Opposition,
                playerTopMinutes.First(y => y.Team == x.Key).OU,
                playerTopMinutes.First(y => y.Team == x.Key).Line,
                playerTopMinutes.First(y => y.Team == x.Key).FV,
            }).ToList();

            games = games.OrderBy(x => (x.TotalTeamScore + x.OpposingTeamScore)).ToList();

            return Json(JsonConvert.SerializeObject(games));
        }

        public IActionResult GetGridData(string sidx, string sord, int page, int rows, bool _search, string filters, string team, string mp)
        {
            sidx = sidx.Replace("Team asc, ", "");
            if (HttpContext.Session.GetString("NCAAPrediction") != null)
            {
                List<NCAAPlayerViewModel> playerList = Session.GetObject<List<NCAAPlayerViewModel>>("NCAAPrediction");

                if (!string.IsNullOrWhiteSpace(sidx))
                {
                    sidx = char.ToUpper(sidx[0]) + sidx.Substring(1);
                    if (sord == "asc")
                    {
                        playerList = playerList.OrderBy(x => x.GetType().GetProperty(sidx).GetValue(x, null)).ThenBy(x => x.Team).ToList();
                    }
                    else
                    {
                        playerList = playerList.OrderByDescending(x => x.GetType().GetProperty(sidx).GetValue(x, null)).ThenBy(x => x.Team).ToList();
                    }
                }
                else
                {
                    playerList = playerList.OrderBy(x => x.Team).ToList();
                }

                if (!string.IsNullOrWhiteSpace(team))
                {
                    playerList = playerList.FindAll(x => x.Team.ToLower().Contains(team.ToLower()) || x.Opposition.ToLower().Contains(team.ToLower()) ).ToList();
                }

                if (!string.IsNullOrWhiteSpace(mp))
                {
                    playerList = playerList.FindAll(x => x.MinutesPlayed.Minutes >= int.Parse(mp)).ToList();
                }


                return Json(new { data = playerList });
            }

            return Json(new { });
        }

    }
}