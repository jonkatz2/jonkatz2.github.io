// set the dimensions and margins of the graph
var origmargin = {top: 10, right: 10, bottom: 10, left: 10},
  width = 1000 - origmargin.left - origmargin.right,
  height = 250 - origmargin.top - origmargin.bottom;
  
// set the dimensions and margins of the graph
var margin = {top: 5, right: 285, bottom: 30, left: 40},
  newwidth = width - margin.left - margin.right,
  newheight = height - margin.top - margin.bottom;

// the colors in the legend and the barplot are pulled from here
//// this could come from the data  
var alterations = [
  {name:"High level amplification", color:"#8B0000", type:"Amp"}, 
  {name:"Low level gain", color:"#ff5733", type:"Gain"}, 
  {name:"Shallow deletion", color:"#00b8ff", type:"HetLoss"}, 
  {name:"Deep deletion", color:"#00008B", type:"HomDel"}, 
  {name:"Mutation", color:"#169e35", type:"Mutation"}, 
  {name:"Fusion", color:"#ffc125", type:"Fusion"}
];

//var options = {
//  frequencies: [{name:"NOTCH1", frq:"1%"}, {name:"EGFR", frq:"2%"}, {name:"BRCA1", frq:"3%"}, {name:"BRCA2", frq:"4%"}, {name:"PLEKHA1", frq:"5%"}]
//};

// append the svg object to the body of the page
var svg = d3.select("#oncoprint")
.append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
.append("g")
  .attr("transform",
        "translate(" + margin.left + "," + margin.top + ")");

//Read the data
d3.csv("/assets/blog/oncoprint/genedata2.csv").then(function(data) {

  var g = svg.append("g")
    .attr("class", "outer-holder")
    .attr("transform", "translate(" + margin.left + "," + (margin.top+45) + ")");

        // data in
        // Labels of row and columns -> unique identifier of the column called 'group' and 'variable'
        
        // clear everything on re-draw
//        svg.selectAll("rect").remove()
//        svg.selectAll(".y1-axis").remove()
//        svg.selectAll(".y2-axis").remove()
//        svg.selectAll(".barplot").remove()
//        svg.selectAll("#oncoprintAreaClip").remove()
        
        // get unique values of models and genes
        var myGroups = d3.map(data, function(d){return d.group;}).keys()
        var myVars = d3.map(data, function(d){return d.variable;}).keys()
        
        // use a fixed bar height until the box is full, then compress it
        newheight = Math.min(newheight, 31 * myVars.length);
        
        var plotArea = g.append("g")
          .attr("clip-path", "url(#oncoprintAreaClip)");

        // update: set width and height of clippath rect
        plotArea.append("clipPath")
          .attr("id", "oncoprintAreaClip")
          .append("rect")
          .attr('width', newwidth)
          .attr('height', newheight);
        
        // Build X scales and axis:
        var x = d3.scaleLinear()
          .range([ 0, newwidth ])
          .domain([0, myGroups.length]);
          
  //// Zooming not possible with ordinal scales
  //      // Build X scales and axis:
  //      var x = d3.scaleBand()
  //        .range([ 0, newwidth ])
  //        .domain(myGroups)
  //        .padding(0.05);
  ////      svg.append("g")
  ////        .style("font-size", 15)
  ////        .attr("transform", "translate(0," + height + ")")
  ////        .call(d3.axisBottom(x).tickSize(0))
  ////        .select(".domain").remove()

        // Build Y scales and axis:
        var y = d3.scaleBand()
          .range([ newheight, 0 ])
          .domain(myVars)
          .padding(0.05);
        g.append("g")
          .attr("class", "y1-axis")
          .style("font-size", "1em")
          .call(d3.axisLeft(y).tickSize(0))
          .select(".domain").remove();
        
       
//       // the second y axis is not a real axis because the values may not be unique   
//       var y2 =  g.append("g")
//          .attr("transform", "translate(" + newwidth + ",0)")
//          .attr("class", "y2-axis")
//          .style("font-size", "0.9em");
//  //        .call(d3.axisRight(y2).tickSize(0))
//  //        .select(".domain").remove();
//       // labels
//        y2.selectAll()
//          .data(options.frequencies)
//          .enter()
//          .append("text")
//            .style("font-size", "0.9em")
//            .attr("x", 3)
//            .attr("y", function(d) { return y(d.name) + y.bandwidth()/2 + 2 }) 
//          .text(function(d) { return d.frq })
//          .exit()
     
        
        // create a context menu for the gene right-click
        d3.select("body").selectAll(".genecontext-menu").remove();
        var genemenu = d3.select("body")
          .append("div")
          .style("opacity", 0)
          .attr("class", "genecontext-menu")
          .attr("data-toggle", "modal")
          .attr("data-target", "#lollipopmodal")
          .style("background-color", "rgb(51, 51, 51, 0.9)")
          .style("color", "#FFF")
  //        .style("border", "solid")
  //        .style("border-width", "2px")
  //        .style("border-radius", "5px")
          .style("padding", "5px")
          .style("position", "absolute")
          .style("z-index", "-1");
        
  //      var genemouseover = function(d) {
  //        genemenu
  //          .style("background-color", "#bfbfbf !important")
  //          .style("color", "#333 !important")
  //          .style("border", "1px #333 solid")
  //      }
  //      var genemouseleave = function(d) {
  //        genemenu
  //          .style("background-color", "rgb(51, 51, 51, 0.9)")
  //          .style("color", "#FFF !important")
  //          .style("border", "1px #333 transparent")
  //      }

        // show the gene context menu on right-click and feed it data
        var showgenecontext = function(d) {
          genemenu
            .html("Lollipop plot for "+ d)
            .style("opacity", 1)
            .style("z-index", "10000")
            .style("left", (d3.event.pageX + 15) + "px")
            .style("top", (d3.event.pageY - 15) + "px")
//            .on("click", function (i) {
//              Shiny.setInputValue("mutation-lolliplot_gene", d, {priority: "event"});
//            })
        }
        // this selection group contains model names selected by brushing
        var selgrp = [];
        // create a context menu for the brush right-click
        d3.select("body").selectAll(".brushcontext-menu").remove();
        var brushmenu = d3.select("body")
          .append("div")
          .style("opacity", 0)
          .attr("class", "brushcontext-menu")
          .style("background-color", "rgb(51, 51, 51, 0.9)")
          .style("color", "#FFF")
  //        .style("padding", "5px")
          .style("position", "absolute")
          .style("z-index", "-1");
        // the ul container
        var brushbuttons = brushmenu.append("ul")
          .style("list-style", "none")
          .style("margin-bottom", "0px")
          .style("padding", "0px")
        var brushlist = brushbuttons.selectAll("li")
          .data(["Add selection to cart", "Replace cart with selection"])
          
        brushlist.exit().remove()
        
        brushlist.enter().append("li")
          .html(function(d) {return d;})
          .style("padding", "3px 5px")
          .attr("class", function(d, i) { return "brushitem"+i })
        
        // show the brush context menu on right-click
        var showbrushcontext = function(d) {
          // turn off any prior click events
          $(".brushitem0").off("click");
          $(".brushitem1").off("click");
          // un-hide the brush menu
          brushmenu
            .style("opacity", 1)
            .style("z-index", "10000")
            .style("left", (d3.event.pageX + 15) + "px")
            .style("top", (d3.event.pageY - 15) + "px");
//          // set the click event using jQuery  
//          $(".brushitem1").click(function() { 
//            Shiny.setInputValue("mutation-oncoprintselectionreplace", selgrp, {priority: "event"}) 
//          });
//          $(".brushitem0").click(function() { 
//            Shiny.setInputValue("mutation-oncoprintselectionadd", selgrp, {priority: "event"}) 
//          });
        }
             
        // Add links to the gene/y-axis
        g.selectAll(".y1-axis").selectAll('.tick')
          .data(myVars)
          .attr("gene", function(d) { return d })
//          .on('click', function (d) {
//            zoom.transform(oncoprint, d3.zoomIdentity);
//            Shiny.setInputValue("mutation-gene_priority", d, {priority: "event"});
//          })
          .on("contextmenu", function (d, i) {
            d3.event.preventDefault()
            showgenecontext(d)
          })
          .exit();

        // remove all tooltips
        d3.select("body").selectAll(".oncoprinttooltip").remove();
        // create a tooltip
        var tooltip = d3.select("body")
          .append("div")
          .style("opacity", 0)
          .attr("class", "oncoprinttooltip")
          .style("background-color", "rgb(51, 51, 51, 0.9)")
          .style("color", "#FFF")
  //        .style("border", "solid")
  //        .style("border-width", "2px")
  //        .style("border-radius", "5px")
          .style("padding", "5px")
          .style("position", "absolute");


        // Three functions that change the tooltip when user hover / move / leave a cell
        var mouseover = function(d) {
          tooltip
            .style("opacity", 1)
            .style("z-index", 1000)
          d3.select(this)
            .style("stroke", "black")
            .style("opacity", 1) 
        }
        var mousemove = function(d) {
          if (d.mutation == "") {var mut = ""} 
          else {var mut = "<tr><td class='lab' style='vertical-align:top;'>Mutation</td><td>" + d.mutation + "</td></tr>"}
          tooltip
            .html("<table><tr><td class='lab'>Sample</td><td>" + d.group + "</td></tr><tr><td class='lab'>Gene</td><td>" + d.variable + "</td></tr><tr><td class='lab'>Alteration</td><td>" + d.value + "</td></tr>" + mut + "</table>")
            .style("left", (d3.event.pageX + 15) + "px")
            .style("top", (d3.event.pageY - 15) + "px")
  //          .style("left", (d3.mouse(this)[0]+70) + "px")
  //          .style("top", (d3.mouse(this)[1]+(2*y.bandwidth())) + "px")
  //          .style("top", (d3.mouse(this)[1]) + "px")
        }
        var mouseleave = function(d) {
          tooltip
            .style("opacity", 0)
            .style("z-index", -1)
          d3.select(this)
            .style("stroke", "none")
            .style("opacity", 0.8)
        }
        
        
        // brush region under oncoprint, extends top and bottom for area to grab
        var brush = d3.brushX()
          .extent([[-10, -20], [newwidth+10, newheight+20]])
          .on("start", brushstart)
          .on("brush", brushing)
          .on("end", brushend);

        var brushgroup = g.append("g")
          .attr("class", "brushed")
          .on("contextmenu", function (d) {
            d3.event.preventDefault()
            showbrushcontext()
          })
          .call(brush);
        
        // zoom region exactly matches the oncoprint area
        var zoom = d3.zoom()
          .scaleExtent([1, Infinity])
          .translateExtent([[0, 0], [newwidth, newheight]])
          .extent([[0, 0], [newwidth, newheight]])
          .on("zoom", zooming)
  //        .on("end", zoomend);

        
        // record the alterations per gene as we draw the rectangles
        var altcount = {};
        myVars.forEach(function(d) {
          altcount = {...altcount, [d]:{Amp:0,Gain:0,HetLoss:0,HomDel:0,Fusion:0,Mutation:0}}; 
        });
        
        // record the samples with alterations per gene as we draw the rectangles
        var samplecount = {};
        myVars.forEach(function(d) {
          samplecount = {...samplecount, [d]:[]}; 
        });

        
        var oncoprint = g.append("g")
          .attr("class", "oncoprint")
          .call(zoom);
  //        .on("dblclick.zoom", null)
  //        .call(brush);
                 
          
        // add the primary squares
        var alterationrect = oncoprint.selectAll()
          .data(data)
          .enter()
          .append("rect")
            .attr("class", "cna")
            .attr("x", function(d) { return x(myGroups.indexOf(d.group)); })
  //          .attr("x", function(d) { return x(d.group) })
            .attr("y", function(d) { return y(d.variable) })
            .attr("width", function(d) { return (x(myGroups.indexOf(d.group)+0.9) - x(myGroups.indexOf(d.group))); })
  //          .attr("width", x.bandwidth() )
            .attr("height", y.bandwidth() )
  //          .attr("group", function(d) { return d.group })
            .style("fill", function(d) {
              if (d.value == "Amp") {altcount[d.variable].Amp += 1; samplecount[d.variable].push(d.group); return "#8B0000"} 
              else if (d.value == "Gain" ) {altcount[d.variable].Gain += 1; samplecount[d.variable].push(d.group); return "#ff5733"}
              else if (d.value == "HetLoss") {altcount[d.variable].HetLoss += 1; samplecount[d.variable].push(d.group); return "#00b8ff"}
              else if (d.value == "HomDel") {altcount[d.variable].HomDel += 1; samplecount[d.variable].push(d.group); return "#00008B"}
              else { return "#D3D3D3" }//return myColor(d.value)  }
            })
            .style("stroke-width", 4)
            .style("stroke", "none")
            .style("opacity", 0.8)
          .on("mouseover", mouseover)
          .on("mousemove", mousemove)
          .on("mouseleave", mouseleave)
          .exit()
         
        // add the mutation squares
        var mutationrect = oncoprint.selectAll()
          .data(data)
          .enter()
          .append("rect")
            .attr("class", "mut")
            .attr("x", function(d) { return x(myGroups.indexOf(d.group)); })
  //          .attr("x", function(d) { return x(d.group) })
            .attr("y", function(d) { return y(d.variable) })
            .attr("width", function(d) { return (x(myGroups.indexOf(d.group)+0.9) - x(myGroups.indexOf(d.group))); })
  //          .attr("width", x.bandwidth() )
            .attr("height", function(d) {
              if (d.mutation == "") { return 0 }
              else { return y.bandwidth()/3 }
            })
            .attr("transform", "translate(0," + y.bandwidth()/3 + ")")  
            .style("fill", function(d) { 
              if (d.mutation == "") {return "transparent"}
              else if (d.mutation.match(/Fusion/) != null) {altcount[d.variable].Fusion += 1; samplecount[d.variable].push(d.group); return "#ffc125"}
  //            else if (d.mutation == "InDel") {return "#169e35"}
  //            else if (d.mutation == "SNV") {return "#800000"}
              else { altcount[d.variable].Mutation += 1; samplecount[d.variable].push(d.group); return "#169e35" }//return myColor(d.value)  }
            })
      //      .style("stroke-width", 4)
      //      .style("stroke", "none")
      //      .style("opacity", 0.8)
          .on("mouseover", mouseover)
          .on("mousemove", mousemove)
          .on("mouseleave", mouseleave)
          .exit()
        
        
        // this brush fn before any zooming
        function brushing() {
          selgrp = [];
          if (d3.event.sourceEvent.type === "brush") return;
          var selection = d3.event.selection;
          if (selection == null) {
            selgrp = [];
          } else {
            var x0 = Math.round(x.invert(selection[0])),
                x1 = Math.round(x.invert(selection[1]));
            // snap to boundaries
            d3.select(this).call(d3.event.target.move, [x(x0), x(x1+0.9)]);
            myGroups.forEach(function (d, i) {
              if (x0 <= i && i <= x1)
                selgrp.push(d);
            });
          }
        }
        
        // clear the selectd models before the next selection
        function brushstart() {
          selgrp = [];
        }
        
        
        function zooming() {
          if (d3.event.sourceEvent && d3.event.sourceEvent.type === "brush") return; // ignore zoom-by-brush
  //        if(!d3.event.sourceEvent.ctrlKey) {
          var rescaleX = d3.event.transform.rescaleX(x);
          
          // confine the brush selection on zoom
          brush = d3.brushX()
            .extent([[-10, -20], [newwidth+10, newheight+20]])
            .on("start", brushstart)
            .on("brush", brushing)
            .on("end", brushend);
          brushgroup.call(brush);
          // this brush fn is used after zooming
          function brushing() {
            selgrp = [];
            if (d3.event.sourceEvent.type === "brush") return;
            var selection = d3.event.selection;
            if (selection == null) {
              selgrp = [];
            } else {
              var x0 = Math.round(rescaleX.invert(selection[0])),
                  x1 = Math.round(rescaleX.invert(selection[1]));
              // snap to boundaries
              d3.select(this).call(d3.event.target.move, [rescaleX(x0), rescaleX(x1+0.9)]);
              myGroups.forEach(function (d, i) {
                if (x0 <= i && i <= x1)
                  selgrp.push(d);
              });
            }
          }
          
          // maintain brush position on zoom
          g.select(".brushed").call(brush.move, function(d) {
            if(selgrp.length) {
              var selection = d3.event.selection;
              var x0 = rescaleX(myGroups.indexOf(selgrp[0])),
                  x1 = rescaleX(myGroups.indexOf(selgrp[selgrp.length-1]));
              x0 = Math.max(x0, 0);
              x1 = Math.min(x1, newwidth);
              // snap to boundaries
              return [x0, x1];
            }
          });
          
          // redraw rectangles on zoom
          oncoprint.selectAll("rect.cna")
            .attr('clip-path', 'url(#oncoprintAreaClip)')
            .attr("x",function(d){ return rescaleX(myGroups.indexOf(d.group)); })
            .attr("y",function(d){ return y(d.variable); })
            .attr('width', function(d) { return (rescaleX(myGroups.indexOf(d.group)+0.9)-rescaleX(myGroups.indexOf(d.group))); })
            .attr("height", function(d) { return y.bandwidth(); })
            .style("fill", function(d) {
              if (d.value == "Amp") {altcount[d.variable].Amp += 1; return "#8B0000"} 
              else if (d.value == "Gain" ) {altcount[d.variable].Gain += 1; return "#ff5733"}
              else if (d.value == "HetLoss") {altcount[d.variable].HetLoss += 1; return "#00b8ff"}
              else if (d.value == "HomDel") {altcount[d.variable].HomDel += 1; return "#00008B"}
              else { return "#D3D3D3" }
            })
          oncoprint.selectAll("rect.mut")
            .attr('clip-path', 'url(#oncoprintAreaClip)')
            .attr("x",function(d){ return rescaleX(myGroups.indexOf(d.group)); })
            .attr("y",function(d){ return y(d.variable); })
            .attr('width', function(d) { return (rescaleX(myGroups.indexOf(d.group)+0.9)-rescaleX(myGroups.indexOf(d.group))); })
            .attr("height", function(d) {
              if (d.mutation == "") { return 0 }
              else { return y.bandwidth()/3 }
            })
            .attr("transform", "translate(0," + y.bandwidth()/3 + ")")  
            .style("fill", function(d) { 
              if (d.mutation == "") {return "#transparent"}
              else if (d.mutation.match(/Fusion/) != null) {altcount[d.variable].Fusion += 1; return "#ffc125"}
              else { altcount[d.variable].Mutation += 1; return "#169e35" }
            })
            
            // zoom status
            svg.select(".zoom-status").remove()
            svg.append("text")
              .attr("class", "zoom-status")
              .attr("x", 25)
              .attr("y", 25)
              .attr("text-anchor", "left")
              .style("font-size", "0.9em")
              .style("fill", "#333;")
              .style("max-width", newwidth/2)
              .text("Zoom: " + Math.round(rescaleX(myGroups.length-1)/newwidth*10)/10 + "x");

  //          }
        }  
        
        // send the brushed selection to the DOM element on zoomend --
        function brushend() {
          if (selgrp.length) {
            // don't resend on zoom
            if (d3.event.sourceEvent.type == "zoom") return;
//            Shiny.setInputValue("mutation-brush_selection", selgrp, {priority: "event"});
          } 
        }
        
  // the stacked barplot of total alterations by type //
  // tooltip shows the count of the color-within-bar on hover
  var barmousemove = function(d) {
    tooltip
      .html((d[1]-d[0]))
      .style("left", (d3.event.pageX + 15) + "px")
      .style("top", (d3.event.pageY - 15) + "px")
  }

//  // the colors in the legend and the barplot are pulled from here
//  //// this could come from the data  
//  var alterations = [
//    {name:"High level amplification", color:"#8B0000", type:"Amp"}, 
//    {name:"Low level gain", color:"#ff5733", type:"Gain"}, 
//    {name:"Shallow deletion", color:"#00b8ff", type:"HetLoss"}, 
//    {name:"Deep deletion", color:"#00008B", type:"HomDel"}, 
//    {name:"Mutation", color:"#169e35", type:"Mutation"}, 
//    {name:"Fusion", color:"#ffc125", type:"Fusion"}
//  ]

  // convert the alteration counter to an array
  var altmat = []
  myVars.forEach(function(d) {
    var temp = altcount[d]
    temp["name"] = d;
    altmat.push(temp);
  });

  // make a barplot area to the right of the percentages
  var barplot =  g.append("g")
    .attr("transform", "translate(" + (newwidth+35) + ",0)") 
    .attr("class", "barplot")

  // stack bars
  var barstack = d3.stack()
    .keys(["Amp", "Gain", "HetLoss", "HomDel", "Mutation", "Fusion"])
    .order(d3.stackOrderNone)
    .offset(d3.stackOffsetNone);
    
  // convert stacked bars to series-based array     
  var barseries = barstack(altmat); 

  // identify the highest alteration count in any gene
  var altctmax = d3.max(barseries, function(d) {return d3.max(d, function(j) { return +j[1];});});

  //var altctmax = d3.max(d3.max(barseries), function(d) {return d[1];});
  // Scale the barplot to fit in the alotted 65px
  var bary = d3.scaleLinear()
    .domain([0, altctmax])
    .range([0, 65]); 
  // add an axis
  barplot.append("g")
    .attr("transform", "translate(0,-1)") 
    .style("font-size", 6)
    .call(d3.axisTop(bary).ticks(3).tickSize(3).tickValues([0, Math.round(altctmax/2),	altctmax]))
    .select(".domain").remove()

  // Draw the barplot rectangles
  barplot.selectAll()
    .data(barseries)
    .enter().append("g")
      .attr("class", "serie")
      .attr("fill", function(d, i) { return alterations[i].color; })
    .selectAll()
    .data(function(d) { return d; })
    .enter().append("rect")
      .attr("x", function(d) { return bary(d[0]); })
      .attr("y", function(d, i) { return y(myVars[i]); })
      .attr("width", function(d) { return bary((d[1] - d[0])); })
      .attr("height", y.bandwidth())
      .on("mouseover", mouseover)
      .on("mousemove", barmousemove)
      .on("mouseleave", mouseleave);
     
     
  // plot title
  svg.select(".title").remove()
  svg.append("text")
    .attr("class", "title")
    .attr("x", newwidth/2)
    .attr("y", 25)
    .attr("text-anchor", "left")
    .style("font-size", "1.1em")
    .style("fill", "#333;")
    .style("max-width", width)
    .text(myGroups.length + " Samples");
 
   
   // the second y axis is not a real axis because the values may not be unique   
   var y2 =  g.append("g")
      .attr("transform", "translate(" + newwidth + ",0)")
      .attr("class", "y2-axis")
      .style("font-size", "0.9em");
//        .call(d3.axisRight(y2).tickSize(0))
//        .select(".domain").remove();
   // labels
    y2.selectAll()
      .data(myVars)
      .enter()
      .append("text")
        .style("font-size", "0.7em")
        .attr("x", 3)
        .attr("y", function(d) { return y(d) + y.bandwidth()/2 + 2 }) 
      .text(function(d) { return Math.round([...new Set(samplecount[d])].length/myGroups.length*100) + "%" })
      .exit()

// data out    
})   
      
//// add a legend
// group the legend
svg.selectAll(".legend").remove()
var legend = svg.append("g")
  .attr("transform", "translate(" + (newwidth+margin.left+70+45) + "," + (margin.top+45) + ")")
  .attr("class", "legend")

// legend title
legend.append("text")
  .attr("x", 0)
  .attr("y", 10)
  .style("font-size", "0.9em")
  .text("Alterations")
  .exit();

// colored rects      
legend.selectAll()
  .data(alterations)
  .enter()
  .append("rect")
    .attr("x", 0)
    .attr("y", function(d, i) { return (16 * i + 20) })
    .attr("width", 8 )
    .attr("height", 14 )
    .style("fill", function(d) { return d.color })
  .exit();

// labels
legend.selectAll()
  .data(alterations)
  .enter()
  .append("text")
    .style("font-size", "0.8em")
    .attr("x", 16)
    .attr("y", function(d, i) { return (16 * i + 31) })
    .text(function(d) { return d.name })
  .exit()





