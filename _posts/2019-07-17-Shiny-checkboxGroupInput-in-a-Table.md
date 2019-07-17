---
layout: post
title: "Shiny checkBoxGroupInput in a Table"
date: 2019-07-17
description: ""
category: 
tags: [R, shiny, javascript, jQuery, custom, input]
---
{% include JB/setup %}

I really like how easy it is to modify the simple inputs in shiny. For example last week I had to make three sets of checkboxGroupInputs, all with the same choices, to control which visuals would appear in a markdown report. My first draft had three distinct inputs, but this was not space efficient and felt completely inelegant. making a table of selections seemed like a much better idea, but of course no such input exists natively in shiny.  

Making an input like this is really simple:
<style>
	#reportgenegrouptable th {
		background: #eee;
		padding: 0em 0.5em;
	}
	#reportgenegrouptable tr:nth-child(even) {
		background: #eee
	}
	#reportgenegrouptable tr:nth-child(odd) {
		background: #FFF
	}
	#reportgenegrouptable td.checkbox {
		text-align: center;
	}
	#reportgenegrouptable td:not(.checkbox) {
		text-align: right;
	}
</style>
<div id="reportlolliplots" class="form-group shiny-input-checkboxgroup shiny-input-container">
  <div id="reportboxplots" class="form-group shiny-input-checkboxgroup shiny-input-container">
	<div id="reporthistograms" class="form-group shiny-input-checkboxgroup shiny-input-container">
		<table id="reportgenegrouptable">
		  <thead><tr>
		<th>Gene Symbol</th>
		<th>Lollipop Plot</th>
		<th>Boxplot</th>
		<th>Histogram</th>
		  </tr></thead>
		<tr>
		  <td style="padding:0px 8px;">NOTCH1</td>
		  <td class="checkbox"><input type="checkbox" name="reportlolliplots" value="NOTCH1"/></td>
		  <td class="checkbox"><input type="checkbox" name="reportboxplots" value="NOTCH1"/></td>
		  <td class="checkbox"><input type="checkbox" name="reporthistograms" value="NOTCH1"/></td>
		</tr> 
		<tr>
		  <td style="padding:0px 8px;">EGFR</td>
		  <td class="checkbox"><input type="checkbox" name="reportlolliplots" value="EGFR"/></td>
		  <td class="checkbox"><input type="checkbox" name="reportboxplots" value="EGFR"/></td>
		  <td class="checkbox"><input type="checkbox" name="reporthistograms" value="EGFR"/></td>
		</tr> 
		<tr>
		  <td style="padding:0px 8px;">TPTE</td>
		  <td class="checkbox"><input type="checkbox" name="reportlolliplots" value="TPTE"/></td>
		  <td class="checkbox"><input type="checkbox" name="reportboxplots" value="TPTE"/></td>
		  <td class="checkbox"><input type="checkbox" name="reporthistograms" value="TPTE"/></td>
		</tr> 
		<tr>
		  <td style="padding:0px 8px;">TP53</td>
		  <td class="checkbox"><input type="checkbox" name="reportlolliplots" value="TP53"/></td>
		  <td class="checkbox"><input type="checkbox" name="reportboxplots" value="TP53"/></td>
		  <td class="checkbox"><input type="checkbox" name="reporthistograms" value="TP53"/></td>
		</tr> 
		<tr>
		  <td style="padding:0px 8px;">KRAS</td>
		  <td class="checkbox"><input type="checkbox" name="reportlolliplots" value="KRAS"/></td>
		  <td class="checkbox"><input type="checkbox" name="reportboxplots" value="KRAS"/></td>
		  <td class="checkbox"><input type="checkbox" name="reporthistograms" value="KRAS"/></td>
		</tr> 
		<tr>
		  <td style="padding:0px 8px;">BRCA1</td>
		  <td class="checkbox"><input type="checkbox" name="reportlolliplots" value="BRCA1"/></td>
		  <td class="checkbox"><input type="checkbox" name="reportboxplots" value="BRCA1"/></td>
		  <td class="checkbox"><input type="checkbox" name="reporthistograms" value="BRCA1"/></td>
		</tr> 
		<tr>
		  <td style="padding:0px 8px;">BRCA2</td>
		  <td class="checkbox"><input type="checkbox" name="reportlolliplots" value="BRCA2"/></td>
		  <td class="checkbox"><input type="checkbox" name="reportboxplots" value="BRCA2"/></td>
		  <td class="checkbox"><input type="checkbox" name="reporthistograms" value="BRCA2"/></td>
		</tr>
		</table>
	</div>
  </div>
</div>

This is a dynamic input, so it is rendered on the server and then displayed. Here is the server code:

```
# This would be a reactive that gathers the values from the ui somehow
selectedGene <- function() {
	c("NOTCH1", "EGFR", "TPTE", "TP53", "KRAS", "BRCA1", "BRCA2")
}

# Render the table of genes
output$geneselectiontable <- renderUI({
	genes <- selectedGene()
	trows <- unlist(lapply(genes, function(x) {
		paste0('
			<tr>
			  <td style="padding:0px 8px;">', x, '</td>
			  <td class="checkbox">', tags$input(type="checkbox", name="reportlolliplots", value=x), '</td>
			  <td class="checkbox">', tags$input(type="checkbox", name="reportboxplots", value=x), '</td>
			  <td class="checkbox">', tags$input(type="checkbox", name="reporthistograms", value=x), '</td>
			</tr>'
		)
	}))


	tab <- paste0('
		<table id="', "reportgenegrouptable), '">
		  <thead><tr>
			<th>Gene Symbol</th>
			<th>Lollipop Plot</th>
			<th>Boxplot</th>
			<th>Histogram</th>
		  </tr></thead>' ,
		  paste(trows, collapse=" "), '
		</table>'
	)
	
	div(id="reportlolliplots", class="form-group shiny-input-checkboxgroup shiny-input-container",
		div(id="reportboxplots", class="form-group shiny-input-checkboxgroup shiny-input-container",
			div(id="reporthistograms", class="form-group shiny-input-checkboxgroup shiny-input-container",
				HTML(tab)
			)
		)
	)
})
```

Of course the updateCheckboxGroupInput function no longer works on this table, so we have to modify it a little bit. The reason it no longer works is because it locates the div, clears it, then recreates it, potentially with different choices. Since my table is rendered I can just re-render the table to change the choices, so my update function does not need to add or remove choices -- it only needs to check and un-check the boxes.  

The simplest way to do this is to use a custom message handler. Here's mine, that I source in as a script in my ui:  

```
Shiny.addCustomMessageHandler("updateCheckGroup",
  function(message) {
	// Copied verbatim from shiny.js
	// Escape jQuery selector metacharacters: !"#$%&'()*+,./:;<=>?@[\]^`{|}~
	var exports = window.Shiny = window.Shiny || {};
	var $escape = exports.$escape = function(val) {
	  return val.replace(/([!"#$%&'()*+,.\/:;<=>?@\[\\\]^`{|}~])/g, '\\$1');
	}; 
	// Adapted from shiny.js
    var el = $(message.id + '.shiny-input-checkboxgroup');
    // Clear all checkboxes
    $('input:checkbox[name="' + $escape(message.id) + '"]').prop('checked', false);
    var value = message.value;
    // Accept array
    if (value instanceof Array) {
      for (var i = 0; i < value.length; i++) {
        $('input:checkbox[name="' + $escape(message.id) + '"][value="' + $escape(value[i]) + '"]')
          .prop('checked', true);
      }
    // Else assume it's a single value
    } else {
      $('input:checkbox[name="' + $escape(message.id) + '"][value="' + $escape(value) + '"]')
        .prop('checked', true);
    }

  }
)
```

To use it I collect the choices I want to check and uncheck, and pass them to the messageHandler:  

```
# Update which expression plots to include
observe({
	reportGenes$boxplots
	reportGenes$histograms
	reportGenes$lolliplots
	# This makes sure we can't run until the first gene selections are made
	genes <- selectedGene()
	isolate({
		if(length(genes)) {
			boxplotsalreadyselected <- reportGenes$boxplots
			if(length(boxplotsalreadyselected)) session$sendCustomMessage("updateCheckGroup", message=list(id="reportboxplots", value=boxplotsalreadyselected))
			
			histogramsalreadyselected <- reportGenes$histograms
			if(length(histogramsalreadyselected)) session$sendCustomMessage("updateCheckGroup", message=list(id="reporthistograms", value=histogramsalreadyselected))
			
			lolliplotsalreadyselected <- reportGenes$lolliplots
			if(length(lolliplotsalreadyselected)) session$sendCustomMessage("updateCheckGroup", message=list(id="reportlolliplots", value=lolliplotsalreadyselected))
		}
	})
})
```
<div style="height:200px;"></div>
