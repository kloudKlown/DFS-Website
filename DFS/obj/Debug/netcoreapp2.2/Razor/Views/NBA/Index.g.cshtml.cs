#pragma checksum "D:\DFS Website\DFS\DFS\Views\NBA\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "417eaf1f5349db160f478706f71792e4f2cdfd57"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_NBA_Index), @"mvc.1.0.view", @"/Views/NBA/Index.cshtml")]
[assembly:global::Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute(@"/Views/NBA/Index.cshtml", typeof(AspNetCore.Views_NBA_Index))]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#line 1 "D:\DFS Website\DFS\DFS\Views\_ViewImports.cshtml"
using DFS;

#line default
#line hidden
#line 2 "D:\DFS Website\DFS\DFS\Views\_ViewImports.cshtml"
using DFS.Models;

#line default
#line hidden
#line 1 "D:\DFS Website\DFS\DFS\Views\NBA\Index.cshtml"
using DFS.UI.Common;

#line default
#line hidden
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"417eaf1f5349db160f478706f71792e4f2cdfd57", @"/Views/NBA/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"b389b029d588de670fa900657428202fd15f9a9c", @"/Views/_ViewImports.cshtml")]
    public class Views_NBA_Index : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<DFS.UI.Models.NBAPlayerViewModel>
    {
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_0 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("name", "_NBACourtPartial", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        #line hidden
        #pragma warning disable 0169
        private string __tagHelperStringValueBuffer;
        #pragma warning restore 0169
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext __tagHelperExecutionContext;
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner __tagHelperRunner = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner();
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __backed__tagHelperScopeManager = null;
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __tagHelperScopeManager
        {
            get
            {
                if (__backed__tagHelperScopeManager == null)
                {
                    __backed__tagHelperScopeManager = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager(StartTagHelperWritingScope, EndTagHelperWritingScope);
                }
                return __backed__tagHelperScopeManager;
            }
        }
        private global::Microsoft.AspNetCore.Mvc.TagHelpers.PartialTagHelper __Microsoft_AspNetCore_Mvc_TagHelpers_PartialTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            BeginContext(64, 2, true);
            WriteLiteral("\r\n");
            EndContext();
#line 4 "D:\DFS Website\DFS\DFS\Views\NBA\Index.cshtml"
  
    ViewData["Title"] = "Index";

#line default
#line hidden
            BeginContext(107, 816, true);
            WriteLiteral(@"
<div class=""card no-border col-md-12"">
    <div class=""card-header"">
        Games Today
    </div>
    <div class=""card-body form-group row col-md-12"">
        <div class=""row col-md-12"">
            <div class=""col-md-12"">
                <label class=""col-md-4"">
                    Game Date
                </label>
                <input type=""text"" id=""datepicker"" />
                <span class=""fa fa-calendar-alt fa-cal""></span>
            </div>
        </div>
    </div>
    <div class=""col-md-12 gamepicker"" id=""gamesList"">
        <h6 class=""text-left"">Filter Teams</h6>
        <div class=""cardAll pull-left"">
            <button class=""btn-primary"">
                All
                <i class=""fas fa-check""></i>
            </button>
        </div>
    </div>
</div>

");
            EndContext();
            BeginContext(923, 35, false);
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("partial", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.SelfClosing, "417eaf1f5349db160f478706f71792e4f2cdfd574569", async() => {
            }
            );
            __Microsoft_AspNetCore_Mvc_TagHelpers_PartialTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.PartialTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_PartialTagHelper);
            __Microsoft_AspNetCore_Mvc_TagHelpers_PartialTagHelper.Name = (string)__tagHelperAttribute_0.Value;
            __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_0);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            EndContext();
            BeginContext(958, 13176, true);
            WriteLiteral(@"

<hr />
<hr />
<div id=""ZoneChart"">
    <div class=""card no-border col-md-12"">
        <div class=""row"">
            <div class=""contianer col-md-12"">
                <div class=""card-body"">
                    <table id=""playerShotZone""></table>
                </div>
                <div id=""grdEmail"">
                </div>
            </div>
        </div>
    </div>
</div>


<div class=""card no-border col-md-6"">
    <div class=""row"">
        <div class=""card-header"">
            Player Stats
        </div>
        <div class=""contianer col-md-12"">
            <div class=""card-body"">
                <table id=""jqGrid""></table>
            </div>
        </div>
    </div>
</div>

<script>
    $(function () {
        var date = $(""#datepicker"");
        var gamesList = $(""#gamesList"");
        var court = $(""#NBACourt"");
        var team1Inactive = $(""#T1_InactiveList"")
        var team2Inactive = $(""#T2_InactiveList"")
        var nbaPositions = {}
        var player");
            WriteLiteral(@"ShotZone = $(""#playerShotZone"");
        var playerName = $("".playerName"");

        date.datepicker();
        $("".fa-cal"").on(""click"", function () {
            date.datepicker(""show"");
        })

        date.change(function (e) {
            params = {}
            params.date = $(this).val()

            $.ajax({
                url: ""/NBA/GetGamesForDate"",
                type: ""POST"",
                data: params,
                success: function (data) {
                    PopulateGames(JSON.parse(data));
                },
                error: function () {
                }
            });

        });

        function PopulateGames(data) {
            gamesList.find('.card').remove();
            $.each(data, function (i, value) {
                gamesList.append($(""<div class='card'><button class='TeamName'>"" + value.HomeTeam + ""</button><button class='TeamName'>"" + value.AwayTeam + ""</button>""));
            });
        };

        
        gamesList.on(""cli");
            WriteLiteral(@"ck"", '.TeamName', function (e) {
            console.log($(this).text);
            params = {};
            params.date = date.val();
            params.team = $(this).text();
            params.opp = $(this).parent().text().replace($(this).text(), """");

            $.ajax({
                url: ""/NBA/GetGameStatsByDate"",
                type: ""POST"",
                data: params,
                success: function (data) {
                    clearChartDetials();
                    $(""#jqGrid"").trigger(""reloadGrid"");

                    tabulate();
                    fillChartDetails(data.activePlayerList);
                    fillInactivePlayers(data.inactivePlayersList, params.team);
                },
                error: function () {

                }
            });
        });

        var tabulateShotZones = function (shotData) {
            var gridColNames = [""Shot Type"", ""Shots Made"", ""Shots Taken"", ""Percentage""]

            $(""#playerShotZone"").jqGrid('setGridPa");
            WriteLiteral(@"ram',
                {
                    data: shotData
                })
                .trigger(""reloadGrid"");

            var Columnmodel = [
                { name: 'ShotType', index: 'ShotType', width: 150, align: 'center', editable: false },
                { name: 'MadeShots', index: 'MadeShots', width: 50, align: 'center', editable: false },
                { name: 'TotalShots', index: 'TotalShots', width: 50, align: 'center', editable: false },
                { name: 'ZonePer', index: 'ZonePer', width: 50, align: 'center', editable: false, sortable: true }
            ];

            $(""#playerShotZone"").jqGrid({
                colNames: gridColNames,
                colModel: Columnmodel,                
                datatype: ""local"",
                data: shotData,
                gridview: true,
                loadonce: false,
                rowNum: 100,
                height: ""auto""
            });
        }

        var tabulate = function () {
          ");
            WriteLiteral(@"  var gridColNames = [""Name"", ""Team"", ""Pos"", ""Usage"", ""Mins"", ""Def.R"", ""Off.R"", ""Height"", ""FG"", ""FGA"",
                ""3P"", ""3PA"", ""FT"", ""ORB"", ""DRB"", ""TRB"", ""TRB %"", ""AST"", ""STL"", ""BLK"", ""TOV"", ""PF"", ""PTS""]

            var Columnmodel = [
                {
                    name: 'name', index: 'Name', width: 150, align: 'center', editable: false, classes: ""playerName""
                },
                { name: 'team', index: 'Team', width: 50, align: 'center', editable: false },
                { name: 'multiPosition', index: 'MultiPosition', width: 50, align: 'center', editable: false },
                { name: 'usage', index: 'Usage', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'minutesPlayed', index: 'MinutesPlayed', width: 100, align: 'center', editable: false, sortable: true },
                { name: 'defensiveRating', index: 'DefensiveRating', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'offensiveRat");
            WriteLiteral(@"ing', index: 'OffensiveRating', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'height', index: 'Height', width: 100, align: 'center', editable: false, sortable: true, },
                { name: 'fieldGoal', index: 'FieldGoal', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'fieldGoalAttempted', index: 'FieldGoalAttempted', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'threePointer', index: 'ThreePointer', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'threePointerAttempted', index: 'ThreePointerAttempted', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'freeThrow', index: 'FreeThrow', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'offensiveRebound', index: 'OffensiveRebound', width: 50, align: 'center', editable: false },
                { name: 'defensiveRebou");
            WriteLiteral(@"nd', index: 'DefensiveRebound', width: 50, align: 'center', editable: false },
                { name: 'totalRebound', index: 'TotalRebound', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'totalReboundPercentage', index: 'TotalReboundPercentage', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'assists', index: 'Assists', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'steals', index: 'Steals', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'blocks', index: 'Blocks', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'turnovers', index: 'Turnovers', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'fouls', index: 'Fouls', width: 50, align: 'center', editable: false, sortable: true },
                { name: 'points', index: 'Points', width: 50, align: 'center', editable: ");
            WriteLiteral(@"false, sortable: true }
            ];

            $(""#jqGrid"").jqGrid({
                url: ""/NBA/GetGridData"",
                colNames: gridColNames,
                colModel: Columnmodel,
                pager: '#shotPager',
                datatype: ""json"",
                gridview: true,
                loadonce: false,
                rowNum: 100,
                height: ""auto"",
                repeatitems: false,
                jsonReader: {
                    root: ""data"",
                    repeatitems: false,
                },
            });

        };

        playerName.on(""click"", function (e) {           
            var params = {};
            params[""name""] = $(e.target).text().split(""("")[0];

            //debugger;
            $.ajax({
                url: ""/NBA/GetPlayerZones"",
                type: ""POST"",
                data: params,
                success: function (data) {
                    tabulateShotZones(JSON.parse(data.shotZone));
    ");
            WriteLiteral(@"            },
                error: function () {

                }
            });
        });


        var fillChartDetails = function (data) {
            var primaryTeam = data[0].team;
            var id = 1;
            nbaPositions = {};

            $.each(data, function (i, value) {
                var tableColumns = [""Min"", ""Def"", ""Off"", ""Usa"", ""Eff""]

                if (value.team === primaryTeam) {
                    // Do Nothing
                }
                else {
                    nbaPositions = {};
                    id = 2;
                    primaryTeam = value.team;
                }

                if (String(nbaPositions[value.position]) === ""undefined"") {
                    nbaPositions[value.position] = value.name;

                    // Set Player Name
                    court.find(""#"" + value.position + ""_"" + String(id) + ""_L"").text(value.name + ""("" + String(value.height) + "")"");

                    // Set values in the court tables
");
            WriteLiteral(@"                    $.each(tableColumns, function (t, v) {
                        tableColumns[t] = value.position + ""_"" + String(id) + ""_"" + v;
                    });

                    // Set Player Details
                    court.find(""#"" + tableColumns[0]).text(value.minutesPlayed);
                    court.find(""#"" + tableColumns[1]).text(value.defensiveRating);
                    court.find(""#"" + tableColumns[2]).text(value.offensiveRating);
                    court.find(""#"" + tableColumns[3]).text(value.usage);
                    court.find(""#"" + tableColumns[4]).text(value.points);
                }


            });
        };

        fillInactivePlayers = function (data, team) {
            team1Inactive.find(""label"").remove();
            team2Inactive.find(""label"").remove();

            //$.each(data, function (i, value) {
            //    var text = $(""<label>"" + value.name + "" "" + value.position  + ""</label>"")
            //    if (value.team == team) {
      ");
            WriteLiteral(@"      //        team1Inactive.append(text);
            //    }
            //    else {
            //        team2Inactive.append(text);
            //    }
            //});
        }


        var clearChartDetials = function () {
            var tableColumns = [""Min"", ""Def"", ""Off"", ""Usa"", ""Eff""];
            var positions = [""PG"", ""SG"", ""SF"", ""PF"", ""C""];
            var idList = [];

            $.each(tableColumns, function (i, tblV) {
                $.each(positions, function (i, data) {
                    // Player table Reset
                    idList = idList.concat(""[id^="" + data + ""_1_"" + tblV + ""]"");
                    idList = idList.concat(""[id^="" + data + ""_2_"" + tblV + ""]"");
                    // PlayerName Reset
                    idList = idList.concat(""[id^="" + data + ""_1_L]"");
                    idList = idList.concat(""[id^="" + data + ""_2_L]"");
                });
            });

            court.find(String(idList)).text("""")
        }
        clearChar");
            WriteLiteral(@"tDetials();

        date.val(new Date().toLocaleDateString());
        date.trigger(""change"");
    });

    $(document).ajaxStop(function () {
        var playerName = $("".playerName"");

        playerName.on(""click"", function (e) {           
            var params = {};
            params[""name""] = $(e.target).text().split(""("")[0];

            //debugger;
            $.ajax({
                url: ""/NBA/GetPlayerZones"",
                type: ""POST"",
                data: params,
                success: function (data) {
                    tabulateShotZones(JSON.parse(data.shotZone));
                },
                error: function () {

                }
            });
        });

        
        var tabulateShotZones = function (shotData) {
            var gridColNames = [""Shot Type"", ""Shots Made"", ""Shots Taken"", ""Percentage""]

            $(""#playerShotZone"").jqGrid('setGridParam',
                {
                    data: shotData
                })
         ");
            WriteLiteral(@"       .trigger(""reloadGrid"");

            var Columnmodel = [
                { name: 'ShotType', index: 'ShotType', width: 150, align: 'center', editable: false },
                { name: 'MadeShots', index: 'MadeShots', width: 50, align: 'center', editable: false },
                { name: 'TotalShots', index: 'TotalShots', width: 50, align: 'center', editable: false },
                { name: 'ZonePer', index: 'ZonePer', width: 50, align: 'center', editable: false, sortable: true }
            ];

            $(""#playerShotZone"").jqGrid({
                colNames: gridColNames,
                colModel: Columnmodel,
                datatype: ""local"",
                data: shotData,
                gridview: true,
                loadonce: false,
                rowNum: 100,
                height: ""auto""
            });
        };
    });
</script>
");
            EndContext();
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<DFS.UI.Models.NBAPlayerViewModel> Html { get; private set; }
    }
}
#pragma warning restore 1591
