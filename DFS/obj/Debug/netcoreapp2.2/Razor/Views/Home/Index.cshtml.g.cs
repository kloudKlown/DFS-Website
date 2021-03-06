#pragma checksum "C:\Users\suhas\Source\Repos\kloudKlown\DFS-Website\DFS\Views\Home\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "6d48fba0e004ffac7534d8db493388780f0a7efc"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Home_Index), @"mvc.1.0.view", @"/Views/Home/Index.cshtml")]
[assembly:global::Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute(@"/Views/Home/Index.cshtml", typeof(AspNetCore.Views_Home_Index))]
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
#line 1 "C:\Users\suhas\Source\Repos\kloudKlown\DFS-Website\DFS\Views\_ViewImports.cshtml"
using DFS;

#line default
#line hidden
#line 2 "C:\Users\suhas\Source\Repos\kloudKlown\DFS-Website\DFS\Views\_ViewImports.cshtml"
using DFS.Models;

#line default
#line hidden
#line 1 "C:\Users\suhas\Source\Repos\kloudKlown\DFS-Website\DFS\Views\Home\Index.cshtml"
using DFS.UI.Common;

#line default
#line hidden
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"6d48fba0e004ffac7534d8db493388780f0a7efc", @"/Views/Home/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"b389b029d588de670fa900657428202fd15f9a9c", @"/Views/_ViewImports.cshtml")]
    public class Views_Home_Index : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<DFS.UI.Models.NBAPlayerViewModel>
    {
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
        private global::Microsoft.AspNetCore.Mvc.TagHelpers.FormTagHelper __Microsoft_AspNetCore_Mvc_TagHelpers_FormTagHelper;
        private global::Microsoft.AspNetCore.Mvc.TagHelpers.RenderAtEndOfFormTagHelper __Microsoft_AspNetCore_Mvc_TagHelpers_RenderAtEndOfFormTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
#line 3 "C:\Users\suhas\Source\Repos\kloudKlown\DFS-Website\DFS\Views\Home\Index.cshtml"
  
    ViewData["Title"] = "Home Page";

#line default
#line hidden
            BeginContext(109, 342, true);
            WriteLiteral(@"    <div class=""col-md-12"">
        <h1 class=""display-4"">Welcome</h1>
        <p>Learn about <a href=""https://docs.microsoft.com/aspnet/core"">building Web apps with ASP.NET Core</a>.</p>

        <div class=""card col-md-12"">
            <div class=""card-header text-left"">
                Filter Games
            </div>
            ");
            EndContext();
            BeginContext(451, 726, false);
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("form", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "6d48fba0e004ffac7534d8db493388780f0a7efc3990", async() => {
                BeginContext(457, 713, true);
                WriteLiteral(@"
                <div class=""card-body form-group row col-md-12"">
                    <div class=""col-md-12"">
                        <label class=""col-md-2"">
                            Game Date
                        </label>
                        <input type=""text"" id=""datepicker"" />
                        <span class=""fa fa-calendar-alt fa-cal""></span>
                    </div>
                    <div class=""col-md-12"">
                        <label class=""col-md-2"">
                            Days Before
                        </label>
                        <input type=""text"" id=""daysBefore"" class=""numeric"" />
                    </div>
                </div>
            ");
                EndContext();
            }
            );
            __Microsoft_AspNetCore_Mvc_TagHelpers_FormTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.FormTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_FormTagHelper);
            __Microsoft_AspNetCore_Mvc_TagHelpers_RenderAtEndOfFormTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.RenderAtEndOfFormTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_RenderAtEndOfFormTagHelper);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            EndContext();
            BeginContext(1177, 13074, true);
            WriteLiteral(@"
            <div class=""card-footer"">
                <input type=""button"" value=""Search"" id=""GetGames"" />
            </div>
        </div>
        <div id=""draggable"" class=""ui-widget-content"">
        </div>
        <div id=""droppable"" class=""ui-widget-content"">
        </div>

        <div class=""card row"">
            <div class=""contianer col-md-12"">
                <div class=""row"">
                    <div class=""panel panel-default"">
                        <div class=""panel-heading bg-light-color"" style=""width:1000px;"">
                            <div class=""panel-body no-padding"" style=""width:1000px;"">
                                <table id=""jqGrid"" style=""width:1000px;""></table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id=""groups"">
            <h1 class=""ui-widget-header"">Grouping</h1>
            <div class=""ui-widget-content"">
                ");
            WriteLiteral(@"<ol>
                    <li class=""placeholder"">Drop headers here</li>
                </ol>
            </div>
        </div><table id=""grid""></table>
        <div id=""pager""></div>


    </div>

<script>
    $(function () {
        aggregrateColumns = [""Name"", ""Position"", ""GameDate"", ""Team"", ""Opposition"", ""Home"", ""MinutesPlayed"", ""FieldGoal"", ""FieldGoalAttempted"", ""FieldGoalPercentage"",
            ""ThreePointer"", ""ThreePointerAttempted"", ""ThreePointerPercentage"", ""FreeThrow"", ""FreeThrowAttempted"", ""FreeThrowPercentage"", ""OffensiveRebound"",
            ""DefensiveRebound"", ""TotalRebound"", ""Assists"", ""Steals"", ""Blocks"", ""TurnOvers"", ""PersonalFouls"", ""PointsScored""];

        $('#datepicker').datepicker();
        $("".fa-cal"").on(""click"", function () {
            $(""#datepicker"").datepicker(""show"");
        })

        $(""#GetGames"").on(""click"", function () {
            GetGameResults();
        });

        //function DrawGraph(data) {
        //    tabulate(data, aggregrateColumn");
            WriteLiteral(@"s);
        //    function newRowsAggregrate(data, column) {
        //        var combined = data;

        //        combined = d3.nest().key(
        //            function (d) {
        //                keys = """"
        //                for (x in column) {
        //                    keys = keys + ':' + d[column[x]];
        //                };
        //                return keys;
        //            }
        //        ).rollup(function (d) {
        //            return d3.sum(d, function (g) { return g.Count; });
        //        }).entries(combined)
        //            .map(function (d) {
        //                return {
        //                    ""Keys"": d.key, 'Values': d.values
        //                }
        //            });

        //        newMappedData = [];
        //        $.each(combined, function (key, data) {
        //            newValue = []
        //            newValue[""SiteName""] = combined[key].Keys;

        //            if (""ob");
            WriteLiteral(@"ject"" === typeof (data.Values)) {
        //                $.each(data.Keys, function (each, data) {
        //                    newValue[""WaitlistCategoryCD""] = data.key;
        //                    newValue[""Count""] = data.Values;
        //                });
        //            }
        //            else {
        //                var listValues = newValue[""SiteName""].split(':');
        //                newValue[""SiteName""] = listValues[1];
        //                for (var i = 2; i < listValues.length; i++) {
        //                    newValue[aggregrateColumns[i - 1]] = listValues[i];
        //                }

        //                newValue[""Count""] = data.Values;
        //            }
        //            newMappedData.push(newValue);
        //        });

        //        tabulate(newMappedData, column);
        //    };

        //    newRowsAggregrate(data, aggregrateColumns);
        //}


        var tabulate = function (data, columns) {
     ");
            WriteLiteral(@"       $(""#jqGrid"").clearGridData();
            console.log(data);

            $(""#jqGrid"").jqGrid('setGridParam', { data: data });
            $(""#jqGrid"").trigger(""reloadGrid"");

            var Columnmodel = [
                { name: 'Name', index: 'Name', width: 100, align: 'center', editable: false },
                { name: 'Position', index: 'Position', width: 100, align: 'center', editable: false },
                { name: 'GameDate', index: 'GameDate', width: 100, align: 'center', editable: false, formatter: ""date"" },
                { name: 'Team', index: 'Team', width: 100, align: 'center', editable: false },
            ];

            $(""#jqGrid"").jqGrid({
                colModel: Columnmodel,
                pager: '#grdEmail',
                datatype: ""jsonstring"",
                datastr: data,
                jsonReader: { repeatitems: false },
                rowNum: 2,
                subGrid: false,
                viewrecords: true,
                height: ""auto""");
            WriteLiteral(@",
                ignoreCase: true
            });
        };

        GetGameResults();

        var $grid = $(""#grid"");
        var mydata = [
            { id: ""1"", invdate: ""2010-05-24"", name: ""test"", note: ""note"", tax: ""10.00"", total: ""2111.00"" },
            { id: ""2"", invdate: ""2010-05-25"", name: ""test2"", note: ""note2"", tax: ""20.00"", total: ""320.00"" },
            { id: ""3"", invdate: ""2007-09-01"", name: ""test3"", note: ""note3"", tax: ""30.00"", total: ""430.00"" },
            { id: ""4"", invdate: ""2007-10-04"", name: ""test"", note: ""note"", tax: ""10.00"", total: ""210.00"" },
            { id: ""5"", invdate: ""2007-10-05"", name: ""test2"", note: ""note2"", tax: ""20.00"", total: ""320.00"" },
            { id: ""6"", invdate: ""2007-09-06"", name: ""test3"", note: ""note3"", tax: ""30.00"", total: ""430.00"" },
            { id: ""7"", invdate: ""2007-10-04"", name: ""test"", note: ""note"", tax: ""10.00"", total: ""210.00"" },
            { id: ""8"", invdate: ""2007-10-03"", name: ""test2"", note: ""note2"", amount: ""300.00"", tax: ""21.00");
            WriteLiteral(@""", total: ""320.00"" },
            { id: ""9"", invdate: ""2007-09-01"", name: ""test3"", note: ""note3"", amount: ""400.00"", tax: ""30.00"", total: ""430.00"" },
            { id: ""11"", invdate: ""2007-10-01"", name: ""test"", note: ""note"", amount: ""200.00"", tax: ""10.00"", total: ""210.00"" },
            { id: ""12"", invdate: ""2007-10-02"", name: ""test2"", note: ""note2"", amount: ""300.00"", tax: ""20.00"", total: ""320.00"" },
            { id: ""13"", invdate: ""2007-09-01"", name: ""test3"", note: ""note3"", amount: ""400.00"", tax: ""30.00"", total: ""430.00"" },
            { id: ""14"", invdate: ""2007-10-04"", name: ""test"", note: ""note"", amount: ""200.00"", tax: ""10.00"", total: ""210.00"" },
            { id: ""15"", invdate: ""2007-10-05"", name: ""test2"", note: ""note2"", amount: ""300.00"", tax: ""20.00"", total: ""320.00"" },
            { id: ""16"", invdate: ""2007-09-06"", name: ""test3"", note: ""note3"", amount: ""400.00"", tax: ""30.00"", total: ""430.00"" },
            { id: ""17"", invdate: ""2007-10-04"", name: ""test"", note: ""note"", amount: ""200.00"", tax: ""10.0");
            WriteLiteral(@"0"", total: ""210.00"" },
            { id: ""18"", invdate: ""2007-10-03"", name: ""test2"", note: ""note2"", amount: ""300.00"", tax: ""20.00"", total: ""320.00"" },
            { id: ""19"", invdate: ""2007-09-01"", name: ""test3"", note: ""note3"", amount: ""400.00"", tax: ""30.00"", total: ""430.00"" },
            { id: ""21"", invdate: ""2007-10-01"", name: ""test"", note: ""note"", amount: ""200.00"", tax: ""10.00"", total: ""210.00"" },
            { id: ""22"", invdate: ""2007-10-02"", name: ""test2"", note: ""note2"", amount: ""300.00"", tax: ""20.00"", total: ""320.00"" },
            { id: ""23"", invdate: ""2007-09-01"", name: ""test3"", note: ""note3"", amount: ""400.00"", tax: ""30.00"", total: ""430.00"" },
            { id: ""24"", invdate: ""2007-10-04"", name: ""test"", note: ""note"", amount: ""200.00"", tax: ""10.00"", total: ""210.00"" },
            { id: ""25"", invdate: ""2007-10-05"", name: ""test2"", note: ""note2"", amount: ""300.00"", tax: ""20.00"", total: ""320.00"" },
            { id: ""26"", invdate: ""2007-09-06"", name: ""test3"", note: ""note3"", amount: ""400.00"", tax: """);
            WriteLiteral(@"30.00"", total: ""430.00"" },
            { id: ""27"", invdate: ""2007-10-04"", name: ""test"", note: ""note"", amount: ""200.00"", tax: ""10.00"", total: ""210.00"" },
            { id: ""28"", invdate: ""2007-10-03"", name: ""test2"", note: ""note2"", amount: ""300.00"", tax: ""20.00"", total: ""320.00"" },
            { id: ""29"", invdate: ""2007-09-01"", name: ""test3"", note: ""note3"", amount: ""400.00"", tax: ""30.00"", total: ""430.00"" }
        ],
            getColumnHeaderByName = function (colName) {
                var $self = $(this),
                    colNames = $self.jqGrid(""getGridParam"", ""colNames""),
                    colModel = $self.jqGrid(""getGridParam"", ""colModel""),
                    cColumns = colModel.length,
                    iCol;
                for (iCol = 0; iCol < cColumns; iCol++) {
                    if (colModel[iCol].name === colName) {
                        return colNames[iCol];
                    }
                }
            },
            customFormatDisplayField = function (displa");
            WriteLiteral(@"yValue, value, colModel, index, grp) {
                return getColumnHeaderByName.call(this, colModel.name) + "": "" + displayValue;
            },
            generateGroupingOptions = function (groupingCount) {
                var i, arr = [];
                for (i = 0; i < groupingCount; i++) {
                    arr.push(customFormatDisplayField);
                }
                return {
                    formatDisplayField: arr
                };
            },
            getArrayOfNamesOfGroupingColumns = function () {
                return $('#groups ol li:not(.placeholder)')
                    .map(function () {
                        return $(this).attr('data-column');
                    }).get()
            };

        $grid.jqGrid({
            data: mydata,
            datatype: ""local"",
            height: 'auto',
            rowNum: 30,
            rowList: [10, 20, 30],
            colNames: ['Inv No', 'Date', 'Client', 'Amount', 'Tax', 'Total', 'Notes'],
  ");
            WriteLiteral(@"          colModel: [
                { name: 'id', key: true, width: 60, sorttype: 'int' },
                { name: 'invdate', width: 90, sorttype: 'date', formatter: 'date' },
                { name: 'name', width: 100 },
                { name: 'amount', width: 80, align: 'right', sorttype: 'float', formatter: 'number' },
                { name: 'tax', width: 80, align: 'right', sorttype: 'float' },
                { name: 'total', width: 80, align: 'right', sorttype: 'float' },
                { name: 'note', width: 150, sortable: false }
            ],
            pager: '#pager',
            viewrecords: true,
            sortname: 'name',
            gridview: true,
            caption: 'jqGrid dynamic drag-n-drop grouping'
        });

        $('tr.ui-jqgrid-labels th div').draggable({
            appendTo: 'body',
            helper: 'clone'
        });

        $('#groups ol').droppable({
            activeClass: 'ui-state-default',
            hoverClass: 'ui-state-hover',
");
            WriteLiteral(@"            accept: ':not(.ui-sortable-helper)',
            drop: function (event, ui) {
                var $this = $(this), groupingNames;
                $this.find('.placeholder').remove();
                var groupingColumn = $('<li></li>').attr('data-column', ui.draggable.attr('id').replace('jqgh_' + $grid[0].id + '_', ''));
                $('<span class=""ui-icon ui-icon-close""></span>').click(function () {
                    var namesOfGroupingColumns;
                    $(this).parent().remove();
                    $grid.jqGrid('groupingRemove');
                    namesOfGroupingColumns = getArrayOfNamesOfGroupingColumns();
                    $grid.jqGrid('groupingGroupBy', namesOfGroupingColumns);
                    if (namesOfGroupingColumns.length === 0) {
                        $('<li class=""placeholder"">Drop headers here</li>').appendTo($this);
                    }
                }).appendTo(groupingColumn);
                groupingColumn.append(ui.draggable.text());
 ");
            WriteLiteral(@"               groupingColumn.appendTo($this);
                $grid.jqGrid('groupingRemove');
                groupingNames = getArrayOfNamesOfGroupingColumns();
                $grid.jqGrid('groupingGroupBy', groupingNames, generateGroupingOptions(groupingNames.length));
            }
        }).sortable({
            items: 'li:not(.placeholder)',
            sort: function () {
                $(this).removeClass('ui-state-default');
            },
            stop: function () {
                var groupingNames = getArrayOfNamesOfGroupingColumns();
                $grid.jqGrid('groupingRemove');
                $grid.jqGrid('groupingGroupBy', groupingNames, generateGroupingOptions(groupingNames.length));
            }
        });

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
