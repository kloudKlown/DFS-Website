#pragma checksum "C:\Users\suhas\source\repos\kloudKlown\DFS-Website\DFS\Views\NCAA\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "7e9b82357a20225c63302599eaba7201a246d850"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_NCAA_Index), @"mvc.1.0.view", @"/Views/NCAA/Index.cshtml")]
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
#line 1 "C:\Users\suhas\source\repos\kloudKlown\DFS-Website\DFS\Views\NCAA\Index.cshtml"
using DFS.UI.Common;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"7e9b82357a20225c63302599eaba7201a246d850", @"/Views/NCAA/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"b389b029d588de670fa900657428202fd15f9a9c", @"/Views/_ViewImports.cshtml")]
    public class Views_NCAA_Index : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<DFS.UI.Models.NCAAPlayerViewModel>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n");
#nullable restore
#line 4 "C:\Users\suhas\source\repos\kloudKlown\DFS-Website\DFS\Views\NCAA\Index.cshtml"
  
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
<br />
<div id=""ZoneChart"" class=""col-md-12 noNewLine no-padding"">
    <div class=""card no-border col-md-6 noNewLine no-padding"">
        <div class=""col-md-12"">
            <div class=""card-body-jqgrid col-md-12"">
                <table id=""playerShot");
            WriteLiteral(@"Zone""></table>
            </div>
        </div>
    </div>
    <div class=""card no-border col-md-6 noNewLine no-padding"">
        <div class=""col-md-12"">
            <div class=""card-body-jqgrid col-md-12"">
                <table id=""playerTeamZone""></table>
            </div>
        </div>
    </div>
</div>

<input id=""selectedTeam"" hidden/>

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

    var playerStatColumnNames = [""Name"", ""Team"", ""Predicted"", ""Min Played"", ""SimpleProjection"", ""Allowed"", ""Scored""]

    var playerStatColumn = [
        { name: 'player', index: 'Name', width: 180, align: 'left', editable: false, classes: ""playerName"", summaryType: 'count' },
        { name: 'team', index: 'Team', width: 200, align: 'right', editable: false },
        { name: 'predicted");
            WriteLiteral(@"', index: 'Predicted', width: 70, align: 'right', editable: false, sortable: true, search: false, summaryType: 'sum' },
        {
            name: 'minutesPlayed', index: 'MinutesPlayed', width: 100, align: 'right', editable: false, sortable: true, search: true,
            formatter: function (cellvalue, options, rowObject) {
                return rowObject.minutesPlayed.minutes;
            }
        },
        { name: 'simpleProjection', index: 'SimpleProjection', width: 80, align: 'right', editable: false, sortable: true, search: false, summaryType: 'sum' },
        { name: 'averagePointsAllowed', index: 'AveragePointsAllowed', width: 80, align: 'right', editable: false, sortable: true, search: false },
        { name: 'averagePointsScored', index: 'AveragePointsScored', width: 80, align: 'right', editable: false, sortable: true, search: false },

    ];


    $(function () {
        var date = $(""#datepicker"");
        var gamesList = $(""#gamesList"");
        var selectedTeam = $(""#sel");
            WriteLiteral(@"ectedTeam"");

        date.datepicker();
        $("".fa-cal"").on(""click"", function () {
            date.datepicker(""show"");
        })

        date.change(function (e) {
            params = {}
            params.date = $(this).val()

            $.ajax({
                url: ""/NCAA/GetGamesForDate"",
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
            gamesList.find('br').remove();
            var j = 0;
            $.each(data, function (i, value) {
                j = j + 1;
                gamesList.append($(""<div class='card'>"" +
                    ""<button class='TeamName'>"" + value.HomeTeam + ""</button><button class='TeamName'>"" + value.AwayTeam + ""</button>"" +
        ");
            WriteLiteral(@"            ""<br/>Pre: <b>"" + value.Predicted + "" - "" + value.PredictedOpp +  ' T: ' + Math.round((value.Predicted + value.PredictedOpp) ,2) + ""</b>"" +
                    ""<br/>Avg: <b>"" + value.TotalTeamScore + "" - "" + value.OpposingTeamScore + ""</b>"" +
                    ""<br/>All: <b>"" + value.TeamAllowed + "" - "" + value.OppAllowed +  ' T: ' + Math.round((value.TeamAllowed + value.OppAllowed) ,2) + ""</b>"" +
                    ""<br/>Act: <b>"" + value.Actual + "" - "" + value.ActualOpp +  ' T: ' + Math.round((value.ActualOpp + value.Actual) ,2) + ""</b>"" +
                    ""<br/><b> Line: "" + value.Line + "" OU: "" + value.OU + "" FV: "" + value.FV + ""</b> </div>"")
                );
                if (j % 4 === 0) {
                    gamesList.append($(""<br/>""));
                    j = 0;
                }
            });
        };


        gamesList.on(""click"", '.TeamName', function (e) {
            var params = {};
            params.date = date.val();
            selectedTeam.val($");
            WriteLiteral(@"(this).text());
            
            $(""#jqGrid"").jqGrid({
                prmNames: {
                    _search: true,
                    sidx: ""sidx"",
                    rows: ""numRows"",
                    page: ""page"",
                    sord: ""sortOrder"",
                    filters: null,
                },
                postData: {
                    team: function () { return selectedTeam.val(); },
                    mp: function () { return $(""#gs_jqGrid_minutesPlayed"").val(); }
                },
                url: ""/NCAA/GetGridData"",
                colNames: playerStatColumnNames,
                colModel: playerStatColumn,
                pager: '#shotPager',
                datatype: ""json"",
                gridview: true,
                loadonce: false,
                rowNum: 100,
                height: ""auto"",
                shrinkToFit: false,
                autowidth: true,
                repeatitems: false,
                jsonReader: {
    ");
            WriteLiteral(@"                root: ""data"",
                    repeatitems: false,
                },
                grouping: true,
                groupingView: {
                    groupField: ['team'],
                    groupSummary: [true],
                    groupText: [""<b>{0}</b>""],
                    groupColumnShow: [true],
                    groupCollapse: false,
                    groupOrder: ['asc']
                }
            });
            $(""#jqGrid"").jqGrid('filterToolbar', { stringResult: true, defaultSearch: 'cn' });

            $(""#jqGrid"").trigger(""reloadGrid"");
        });


        var mainGrid = function () {
            $(""#jqGrid"").jqGrid({
                prmNames: {
                    _search: true,
                    sidx: ""sidx"",
                    rows: ""numRows"",
                    page: ""page"",
                    sord: ""sortOrder"",
                    filters: null,
                },
                postData: {
                    name: funct");
            WriteLiteral(@"ion () { return $(""#gs_jqGrid_name"").val() },
                    team: function () { return $(""#gs_jqGrid_team"").val() },
                },
                url: ""/NCAA/GetGridData"",
                colNames: playerStatColumnNames,
                colModel: playerStatColumn,
                pager: '#shotPager',
                datatype: ""json"",
                gridview: true,
                loadonce: false,
                rowNum: 100,
                height: ""auto"",
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
                    groupSummary: [true],
                    groupText: [""<b>{0}</b>""],
                    groupColumnShow: [true],
                    groupCollapse: false,
              ");
            WriteLiteral(@"      groupOrder: ['asc']
                }
            });
            $(""#jqGrid"").jqGrid('filterToolbar', { stringResult: true, defaultSearch: 'cn' });


        };


        date.val(new Date().toLocaleDateString());
        date.trigger(""change"");
    });
</script>");
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
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<DFS.UI.Models.NCAAPlayerViewModel> Html { get; private set; }
    }
}
#pragma warning restore 1591
