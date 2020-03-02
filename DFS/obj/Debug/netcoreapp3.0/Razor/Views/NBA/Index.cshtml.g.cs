#pragma checksum "C:\Users\suhas\source\repos\kloudKlown\DFS-Website\DFS\Views\NBA\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "edd3e916871be6be436801e8bd457d33345921ae"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_NBA_Index), @"mvc.1.0.view", @"/Views/NBA/Index.cshtml")]
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
#nullable restore
#line 1 "C:\Users\suhas\source\repos\kloudKlown\DFS-Website\DFS\Views\_ViewImports.cshtml"
using DFS;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\suhas\source\repos\kloudKlown\DFS-Website\DFS\Views\_ViewImports.cshtml"
using DFS.Models;

#line default
#line hidden
#nullable disable
#nullable restore
#line 1 "C:\Users\suhas\source\repos\kloudKlown\DFS-Website\DFS\Views\NBA\Index.cshtml"
using DFS.UI.Common;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"edd3e916871be6be436801e8bd457d33345921ae", @"/Views/NBA/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"b389b029d588de670fa900657428202fd15f9a9c", @"/Views/_ViewImports.cshtml")]
    public class Views_NBA_Index : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<DFS.UI.Models.NBAPlayerViewModel>
    {
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_0 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("name", "_NBACourtPartial", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        #line hidden
        #pragma warning disable 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext __tagHelperExecutionContext;
        #pragma warning restore 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner __tagHelperRunner = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner();
        #pragma warning disable 0169
        private string __tagHelperStringValueBuffer;
        #pragma warning restore 0169
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
            WriteLiteral("\r\n");
#nullable restore
#line 4 "C:\Users\suhas\source\repos\kloudKlown\DFS-Website\DFS\Views\NBA\Index.cshtml"
  
    ViewData["Title"] = "Index";

#line default
#line hidden
#nullable disable
            WriteLiteral(@"
<div class=""card no-border col-md-12"">
    <div class=""card-header text-white bg-dark"">
        <h4>Player Projections</h4>
    </div>
    <div class=""card-body form-group row col-md-6"">
        <div class=""col-md-12"">
            <label class=""col-md-3"">
                Game Date
            </label>
            <input type=""text"" id=""datepicker"" />
            <span class=""fa fa-calendar-alt fa-cal""></span>
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
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("partial", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.SelfClosing, "edd3e916871be6be436801e8bd457d33345921ae4582", async() => {
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
            WriteLiteral(@"
<br />
<div id=""ZoneChart"" class=""col-md-12 noNewLine no-padding"">
    <div class=""card no-border col-md-4 noNewLine no-padding ZoneChart"">
        <div class=""card-body-jqgrid col-md-10"">
            <table id=""playerShotZone""></table>
        </div>
    </div>
    <div class=""card no-border col-md-4 noNewLine no-padding ZoneChart"">
        <div class=""card-body-jqgrid col-md-10"">
            <table id=""playerTeamZone""></table>
        </div>
    </div>
    <div class=""card no-border col-md-4 noNewLine no-padding ZoneChart"">
        <div class=""card-body-jqgrid col-md-10"">
            <table id=""TopScorerZone""></table>
        </div>
    </div>
</div>

<div class=""card no-border col-md-12"">
    <div class=""row"">
        <div class=""contianer col-md-12"">
            <div class=""card-body-jqgrid"">
                <table id=""jqGrid""></table>
            </div>
        </div>
    </div>
</div>

<script>
    var gridPlayerCoulmns = [
        { name: 'Player', index: 'Player', widt");
            WriteLiteral(@"h: 150, align: 'left', editable: false },
        { name: 'ShotType', index: 'ShotType', width: 100, align: 'right', editable: false },
        { name: 'MadeShots', index: 'MadeShots', width: 50, align: 'right', editable: false },
        { name: 'TotalShots', index: 'TotalShots', width: 50, align: 'right', editable: false },
        { name: 'ZonePer', index: 'ZonePer', width: 50, align: 'right', editable: false, sortable: true }
    ];
    var gridTopScorerCoulmns = [
        { name: 'ShotType', index: 'ShotType', width: 100, align: 'right', editable: false },
        { name: 'MadeShots', index: 'MadeShots', width: 50, align: 'right', editable: false },
        { name: 'TotalShots', index: 'TotalShots', width: 50, align: 'right', editable: false },
        { name: 'ZonePer', index: 'ZonePer', width: 50, align: 'right', editable: false, sortable: true }
    ];

    var gridPlayerCoulmnNames = [""Player"", ""Shot Type"", ""SM"", ""ST"", ""Per.""];
    var gridTopScorerCoulmnNames = [""Shot Type"", ""SM"", ""ST""");
            WriteLiteral(@", ""Per.""];
    var gridTeamColumnNames = [""Team"", ""Shot Type"", ""Shots Made"", ""Shots Taken"", ""Percentage""];
    var gridTeamColumn = [
        { name: 'Team', index: 'Team', width: 50, align: 'left', editable: false },
        { name: 'ShotType', index: 'ShotType', width: 100, align: 'right', editable: false },
        { name: 'MadeShots', index: 'MadeShots', width: 100, align: 'right', editable: false },
        { name: 'TotalShots', index: 'TotalShots', width: 100, align: 'right', editable: false },
        { name: 'ZonePer', index: 'ZonePer', width: 100, align: 'right', editable: false, sortable: true }
    ];
    var playerStatColumnNames = [""Name"", ""Team"", ""Pos"", ""Proj"", ""Salary"", ""Diff"", ""Actual"", ""Usage"", ""Mins"", ""Def.R"", ""Off.R"", ""PTS"", ""Height"", ""FG"", ""FGA"",
        ""3P"", ""3PA"", ""FT"", ""TRB"", ""AST"", ""STL"", ""BLK""]

    var playerStatColumn = [
        { name: 'name', index: 'Name', width: 180, align: 'left', editable: false, classes: ""playerName"" },
        { name: 'team', index: 'Team', w");
            WriteLiteral(@"idth: 50, align: 'right', editable: false },
        { name: 'multiPosition', index: 'MultiPosition', width: 50, align: 'right', editable: false },
        { name: 'predicted', index: 'predicted', width: 70, align: 'right', editable: false, sortable: true, search: false },
        { name: 'salary', index: 'salary', width: 70, align: 'right', editable: false, sortable: true, search: false },
        {
            name: 'salaryDifference', index: 'salaryDifference', width: 70, align: 'right',
            editable: false, sortable: true, search: false, formatter: function (cellvalue, options, rowObject) {
                if (cellvalue < 0) {
                    var brightnessPer = cellvalue * 10 / -rowObject.salary.replace(""$"", """");
                    return ""<div style='color: black; background-color: rgba(250, 120, 107,"" + brightnessPer + "");' >"" + cellvalue + "" </div>"";
                }
                else {
                    var brightnessPer = cellvalue * 10 / rowObject.salary.replace(""$"", ");
            WriteLiteral(@""""");
                    return ""<div style='color: black; background-color: rgba(32, 179, 52,"" + brightnessPer + "");' >"" + cellvalue + "" </div>"";
                }

            }
        },
        { name: 'actual', index: 'actual', width: 50, align: 'right', editable: false, sortable: true, search: false },
        { name: 'usage', index: 'Usage', width: 80, align: 'right', editable: false, sortable: true, search: false },
        {
            name: 'minutesPlayed', index: 'MinutesPlayed', width: 60, align: 'right', editable: false, sortable: true, search: false,
            formatter: function (cellvalue, options, rowObject) {
                return String(cellvalue.minutes) + "":"" + String(cellvalue.seconds);
            }
        },
        { name: 'defensiveRating', index: 'DefensiveRating', width: 80, align: 'right', editable: false, sortable: true, search: false },
        { name: 'offensiveRating', index: 'OffensiveRating', width: 80, align: 'right', editable: false, sortable: true, se");
            WriteLiteral(@"arch: false },
        { name: 'points', index: 'Points', width: 50, align: 'right', editable: false, sortable: true, search: false, summaryType: 'sum' },
        { name: 'height', index: 'Height', width: 80, align: 'right', editable: false, sortable: true, search: false },
        { name: 'fieldGoal', index: 'FieldGoal', width: 50, align: 'right', editable: false, sortable: true, search: false },
        { name: 'fieldGoalAttempted', index: 'FieldGoalAttempted', width: 50, align: 'right', editable: false, sortable: true, search: false, summaryType: 'sum' },
        { name: 'threePointer', index: 'ThreePointer', width: 50, align: 'right', editable: false, sortable: true, search: false },
        { name: 'threePointerAttempted', index: 'ThreePointerAttempted', width: 50, align: 'right', editable: false, sortable: true, search: false, summaryType: 'sum' },
        { name: 'freeThrow', index: 'FreeThrow', width: 50, align: 'right', editable: false, sortable: true, search: false },
        { name: 'totalR");
            WriteLiteral(@"ebound', index: 'TotalRebound', width: 50, align: 'right', editable: false, sortable: true, search: false, summaryType: 'sum' },
        { name: 'assists', index: 'Assists', width: 50, align: 'right', editable: false, sortable: true, search: false },
        { name: 'steals', index: 'Steals', width: 50, align: 'right', editable: false, sortable: true, search: false },
        { name: 'blocks', index: 'Blocks', width: 50, align: 'right', editable: false, sortable: true, search: false },
    ];




    $(function () {
        var date = $(""#datepicker"");
        var gamesList = $(""#gamesList"");
        var court = $(""#NBACourt"");
        var team1Inactive = $(""#T1_InactiveList"")
        var team2Inactive = $(""#T2_InactiveList"")
        var nbaPositions = {}
        var playerShotZone = $(""#playerShotZone"");
        var playerName = $("".playerName"");

        date.datepicker();
        $("".fa-cal"").on(""click"", function () {
            date.datepicker(""show"");
        })

        date.cha");
            WriteLiteral(@"nge(function (e) {
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

        gamesList.on(""click"", '.TeamName', function (e) {
            var params = {};
            params.date = date.val();
            params.team = $(this).text();
            params.opp = $(this).parent().text().replace($(this).text(), """");

       ");
            WriteLiteral(@"     $.ajax({
                url: ""/NBA/GetGameStatsByDate"",
                type: ""POST"",
                data: params,
                success: function (data) {
                    clearChartDetials();
                    $(""#jqGrid"").trigger(""reloadGrid"");

                    mainGrid();
                    FillChartDetails(data.activePlayerList);
                    FillInactivePlayers(data.inactivePlayersList, params.team);
                    GetTeamZoneData(data.activePlayerList, params.team, params.opp);
                },
                error: function () {

                }
            });
        });

        var GetTeamZoneData = function (playerList, team, opp) {
            var params = {};
            params.nameList = [];
            params.team = team;
            params.opp = opp;

            $.each(playerList, function (i, d) {
                if (d.team == team) {
                    params.nameList = params.nameList.concat(d.name);
                }
    ");
            WriteLiteral(@"        });

            $.ajax({
                url: ""/NBA/GetPlayerListZones"",
                type: ""POST"",
                data: params,
                success: function (data) {
                    tabulateTeamShotZones(JSON.parse(data.shotZone));
                },
                error: function () {

                }
            });

            $.ajax({
                url: ""/NBA/GetTopScorerShotChart"",
                type: ""POST"",
                data: { Team: params.opp },
                success: function (data) {
                    tabulateTopScorerShotZones(JSON.parse(data.shotZone));
                },
                error: function () {

                }
            });



        }

        var mainGrid = function () {
            $(""#jqGrid"").jqGrid({
                prmNames: {
                    _search: true,
                    sidx: ""sidx"",
                    rows: ""numRows"",
                    page: ""page"",
                    sord: ""sortO");
            WriteLiteral(@"rder"",
                    filters: null,
                },
                postData: {
                    name: function () { return $(""#gs_jqGrid_name"").val() },
                    team: function () { return $(""#gs_jqGrid_team"").val() },
                },
                url: ""/NBA/GetGridData"",
                colNames: playerStatColumnNames,
                colModel: playerStatColumn,
                pager: '#shotPager',
                datatype: ""json"",
                gridview: true,
                loadonce: false,
                rowNum: 100,
                height: ""auto"",
                multiselect: true,
                shrinkToFit: false,
                autowidth: true,
                repeatitems: false,
                jsonReader: {
                    root: ""data"",
                    repeatitems: false,
                },
                grouping: true,
                groupingView: {
                    groupField: ['team'],
                    groupSummary: [");
            WriteLiteral(@"true],
                    groupText: [""<b>{0}</b>""],
                    groupColumnShow: [true],
                    groupCollapse: false,
                    groupOrder: ['asc']
                },
                onSelectRow: function (rowId, status, e) {
                    var grid = $(""#jqGrid"");
                    var date = $(""#datepicker"").val();
                    var rowValues = grid.jqGrid('getRowData', rowId);
                    var params = {};
                    params[""Date""] = date;
                    params[""Name""] = rowValues.name;
                    params[""Team""] = rowValues.team;

                    debugger;
                    $.ajax({
                        url: ""/NBA/PlayerSelected"",
                        type: ""POST"",
                        data: params,
                        success: function () {
                            console.log(""added"");
                        },
                        error: function () {
                        }
 ");
            WriteLiteral(@"                   });
                },
                loadComplete: function () {
                    var grid = $(""#jqGrid"");
                    grid.find(""input"").addClass(""playerCheckbox"");
                }

            });
            $(""#jqGrid"").jqGrid('filterToolbar', { stringResult: true, defaultSearch: 'cn' });


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
                },
                error: function () {

                }
            });
        });

        var FillChartDetails = function (data) {
            var primaryTeam = data[0].team;
            var id = 1;
            nbaPositions = {};");
            WriteLiteral(@"

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
                    $.each(tableColumns, function (t, v) {
                        tableColumns[t] = value.position + ""_"" + String(id) + ""_"" + v;
                    });

                    // Set Player Details
                    court.find(""#"" + tabl");
            WriteLiteral(@"eColumns[0]).text(value.minutesPlayed);
                    court.find(""#"" + tableColumns[1]).text(value.defensiveRating);
                    court.find(""#"" + tableColumns[2]).text(value.offensiveRating);
                    court.find(""#"" + tableColumns[3]).text(value.usage);
                    court.find(""#"" + tableColumns[4]).text(value.points);
                }


            });
        };

        FillInactivePlayers = function (data, team) {
            team1Inactive.find(""label"").remove();
            team2Inactive.find(""label"").remove();

            //$.each(data, function (i, value) {
            //    var text = $(""<label>"" + value.name + "" "" + value.position  + ""</label>"")
            //    if (value.team == team) {
            //        team1Inactive.append(text);
            //    }
            //    else {
            //        team2Inactive.append(text);
            //    }
            //});
        }

        var tabulateTeamShotZones = function (shotData) {

  ");
            WriteLiteral(@"          $(""#playerTeamZone"").jqGrid({
                colNames: gridTeamColumnNames,
                colModel: gridTeamColumn,
                datatype: ""local"",
                data: shotData,
                gridview: true,
                loadonce: false,
                rowNum: 15,
                height: ""auto"",
                caption: 'Team Zone',
            });

            $(""#playerTeamZone"").jqGrid('setGridParam',
                {
                    data: shotData
                })
                .trigger(""reloadGrid"");
        };

        var tabulateTopScorerShotZones = function (shotData) {

            $(""#TopScorerZone"").jqGrid({
                colNames: gridTopScorerCoulmnNames,
                colModel: gridTopScorerCoulmns,
                datatype: ""local"",
                data: shotData,
                gridview: true,
                loadonce: false,
                rowNum: 15,
                height: ""auto"",
                caption: 'Top Scorer\'s Z");
            WriteLiteral(@"one',
            });

            $(""#TopScorerZone"").jqGrid('setGridParam',
                {
                    data: shotData
                })
                .trigger(""reloadGrid"");
        };


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
");
            WriteLiteral(@"
        var tabulateShotZones = function (shotData) {
            playerShotZone.jqGrid('GridUnload');
            playerShotZone.jqGrid('setGridParam', {
                data: shotData
            }).trigger(""reloadGrid"");

            playerShotZone.jqGrid({
                colNames: gridPlayerCoulmnNames,
                colModel: gridPlayerCoulmns,
                datatype: ""local"",
                data: shotData,
                gridview: true,
                loadonce: false,
                rowNum: 100,
                height: ""auto"",
                caption: 'Player Zone',
            });
        }

        clearChartDetials();
        date.val(new Date().toLocaleDateString());
        date.trigger(""change"");
    });

    // For players spawned in grid after ajaxStop rebind playerName action
    $(document).ajaxStop(function () {
        var playerName = $("".playerName"");

        playerName.on(""click"", function (e) {
            var params = {};
            params[""name");
            WriteLiteral(@"""] = $(e.target).text().split(""("")[0];

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
            $(""#playerShotZone"").jqGrid('GridUnload');
            $(""#playerShotZone"").jqGrid('setGridParam', {
                data: shotData
            }).trigger(""reloadGrid"");

            $(""#playerShotZone"").jqGrid({
                colNames: gridPlayerCoulmnNames,
                colModel: gridPlayerCoulmns,
                datatype: ""local"",
                data: shotData,
                gridview: true,
                loadonce: false,
                rowNum: 100,
                height: ""auto"",
                caption: 'P");
            WriteLiteral("layer Zone\',\r\n            });\r\n        };\r\n    });\r\n</script>\r\n");
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
