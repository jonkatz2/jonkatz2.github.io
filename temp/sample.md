
    <link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script>
      function fourpointslider( id ) {
        // setup highlow range
          $( id + " .sliderpod" ).each(function( i ) {
             $(this).find( ".fourpointslider-vertical .highlow" ).each(function( j ) {
                // read initial values from markup and remove that
                var values = $( this ).text().split(',').map(Number);
                var min = parseFloat( $( this ).data("min") );
                var max = parseFloat( $( this ).data("max") );
                var step = parseFloat( $( this ).data("step") );
                var disab = $( this ).data("disabled");
                var disabled = (disab === 'TRUE' || disab === 'true' || disab === 1 || disab === '1' || disab === true);
                $( this ).empty().slider({
                  range: true,
                  min: min,
                  max: max,
                  step: step,
                  values: values,
                  animate: true,
                  disabled: disabled,
                  orientation: "vertical",
                  slide: function(event, ui) {
                    var ml = $(id + "ml" + i + "_" + j ).slider( "value");
                    if(ui.values[1] < ml | ui.values[0] > ml){
                       return false;
                    } else {
                      return ui.values;
                    }
                  },
                  stop: function(event, ui) {}
              });
            });
          });
          // setup ml point
          $( id + " .sliderpod" ).each(function( i ) {
              $(this).find( ".fourpointslider-vertical .ml" ).each(function( j ) {
                // read initial values from markup and remove that
                var value = parseFloat( $( this ).text() );
                var min = parseFloat( $( this ).data("min") );
                var max = parseFloat( $( this ).data("max") );
                var step = parseFloat( $( this ).data("step") );
                var disab = $( this ).data("disabled");
                var disabled = (disab === 'TRUE' || disab === 'true' || disab === 1 || disab === '1' || disab === true);
                $( this ).empty().slider({
                  value: value,
                  min: min,
                  max: max,
                  step: step,
                  animate: true,
                  disabled: disabled,
                  orientation: "vertical",
                  slide: function(event, ui) {
                    var high = $(id + "highlow" + i + "_" + j ).slider( "values", 1);
                    var low =  $(id + "highlow" + i + "_" + j ).slider( "values", 0);
                    if(ui.value > high | ui.value < low){
                       return false;
                    } else {
                      return ui.value;
                    }
                  },
                  stop: function(event, ui) {}
                });
             });
          });
        };
        function threepointslider( id ) {
        // setup highlow range
        $( id + " > span > span > .highlow" ).each(function( index ) {
          // read initial values from markup and remove that
          var values =  $( this ).text().split(',').map(Number);
          var minval = parseFloat( $( this ).data("min") );
          var maxval = parseFloat( $( this ).data("max") );
          var stepval = parseFloat( $( this ).data("step") );
          var disab = $( this ).data("disabled");
          var disabled = (disab === 'true' || disab === 1 || disab === '1' || disab === true);
          $( this ).empty().slider({
            range: true,
            min: minval,
            max: maxval,
            step: stepval,
            values: values,
            animate: true,
            disabled: disabled,
            orientation: "vertical",
            slide: function(event, ui) { 
              $( id + " .hlabel" + index ).html( $( id + "highlow" + index ).slider( "values", 1 ) );
              $( id + " .llabel" + index ).html( $( id + "highlow" + index ).slider( "values", 0 ) );
              var ml = $(id + "ml" + index ).slider( "value");
              if(ui.values[1] < ml | ui.values[0] > ml){
                 return false;
              } else {
                return ui.values;
              }
            },
            stop: function(event, ui) {},
            change: function(event, ui) {
              $( id + " .hlabel" + index ).html( $( id + "highlow" + index ).slider( "values", 1 ) );
              $( id + " .llabel" + index ).html( $( id + "highlow" + index ).slider( "values", 0 ) );
            }
          });
          $( id + " .hlabel" + index ).html( $( id + "highlow" + index ).slider( "values", 1 ) );
          $( id + " .llabel" + index ).html( $( id + "highlow" + index ).slider( "values", 0 ) );
        });
        // setup ml point
        $( id + " > span > span > .ml" ).each(function( index ) {
          // read initial values from markup and remove that
          var value = parseFloat( $( this ).text() );
          var minval = parseFloat( $( this ).data("min") );
          var maxval = parseFloat( $( this ).data("max") );
          var stepval = parseFloat( $( this ).data("step") );
          var disab = $( this ).data("disabled");
          var disabled = (disab === 'true' || disab === 1 || disab === '1' || disab === true);
          $( this ).empty().slider({
            value: value,
            min: minval,
            max: maxval,
            step: stepval,
            animate: true,
            disabled: disabled,
            orientation: "vertical",
            slide: function(event, ui) { 
              $( id + " .mllabel" + index ).html( $( id + "ml" + index ).slider( "value" ) );
              var high = $(id + "highlow" + index ).slider( "values", 1);
              var low =  $(id + "highlow" + index ).slider( "values", 0);
              if(ui.value > high | ui.value < low){
                 return false;
              } else {
                return ui.value;
              }
            },
            stop: function(event, ui) {},
            change: function(event, ui) {
              $( id + " .mllabel" + index ).html( $( id + "ml" + index ).slider( "value" ) );
            }
          });
          $( id + " .mllabel" + index ).html( $( id + "ml" + index ).slider( "value" ) );
        });
      };
    </script>
    <style>
      .text-bold {
        font-weight:bold;
      }
      
      /*.threepointslider {*/
      /*  padding:1em;*/
      /*  border: 1px solid gray;*/
      /*}*/
      .threepointslider-vertical {
        float:left;
        border-bottom: 1px solid #ddd;
        margin-bottom: 8px;
      }
      .threepointslider-vertical-axis {
        float:left
      }
      .threepointslider > span {
        float:left;
      }
      .threepointslider .x-axislabel {
        text-align:center;
      }
      .threepointslider > span > p {
        clear:both;
        width:6em;
      }
      .threepointslider > span > p > input {
        width:3em;
      }
      .threepointslider .highlow {
        height:300px; 
        float:left; 
        margin:0px 0px 0px 25px;
      }
      /*    #eq > span > .highlow.ui-slider-vertical { */
      /*      width: 0.4em;*/
      /*    }*/
      .threepointslider .highlow .ui-slider-range { 
      /*  background: #729fcf !important; */
        width: 1em !important;
      }
      .threepointslider .highlow .ui-slider-handle { 
        border-color: #729fcf !important; 
      /*      border-radius: 0.7em;*/
      /*      width: 1.4em;*/
      /*      height:1.4em;*/
        border-radius: 0.1em !important;
        width: 1.25em !important;
        height:0.4em !important;
        margin-bottom: -.3em !important;
      }

      .threepointslider .ml {
        height:300px; 
        float:left; 
        margin:0px;
      }
      .threepointslider .ml.ui-slider-vertical { 
        border: none !important;
        background: transparent !important;
      }
      .ml > .ui-slider-handle { 
        width: 0 !important;
        height: 0 !important; 
        border-top: 0.7em solid transparent !important; 
        border-right: 1.4em solid red !important; 
        border-bottom: 0.7em solid transparent !important;
        border-left: 0em solid transparent !important;
        border-radius:0 !important;
        background:transparent !important;
        margin-bottom: -0.8em !important;
      }

      .threepointslider-vertical-ylab {
          margin: 0px 0px 0px 16px;
          float: left;
          width: 3em;
      }

      .threepointslider-vertical-ylab p {
          -ms-transform: rotate(270deg); /* IE 9 */
          -webkit-transform: rotate(270deg); /* Safari 3-8 */
          transform: rotate(270deg);
          margin: 0;
          text-align: center;
      }

      /*###############################*/
      /*Grouped sliders*/
      /*###############################*/
      .sliderpod {
        float:left;
      }

      .fourpointslider-vertical {
        float:left;
        border-bottom: 1px solid #ddd;
        margin-bottom: 8px;
      }
      .fourpointslider-vertical-axis {
        float:left
      }
      .fourpointslider-input > span {
        float:left;
      }
      .fourpointslider-input .x-axislabel {
        padding: 0px 8px;
        text-align:center;
        margin:0px;
      }
      .fourpointslider-input > span > p {
        clear:both;
      }
      .fourpointslider-input > span > p > input {
        max-width: 9em;
        width: 100%;
      }
      .fourpointslider-input .highlow {
        float:left; 
        margin:-1px 0px 0px 8px;
      }
      .fourpointslider-input .ml {
        float:left; 
        margin:-1px 0px 0px 0px;
      }
      .fourpointslider-input .ml.ui-slider-vertical { 
        border: none !important;
        background: transparent !important;
      }
      .fourpointslider-input > span > .sliderpod > span > .ml > .ui-slider-handle { 
        width: 0; 
        height: 0; 
        border-top: 0.7em solid transparent; 
        border-right: 1.4em solid red; 
        border-bottom: 0.7em solid transparent;
        border-left: 0em solid transparent;
        border-radius:0;
        background:transparent;
        margin-bottom: -0.8em;
      }
      .fourpointslider-input > span > .sliderpod > .fourpointslider-vertical > .highlow > .ui-slider-range { 
        width: 1em;
      }
      /*.fourpointslider-input .highlow.fourpointslider0 .ui-slider-range { */
      /*  background: #003366; */
      /*}*/
      /*.fourpointslider-input .highlow.fourpointslider1 .ui-slider-range { */
      /*  background: #66b3ff; */
      /*}*/
      /*.fourpointslider-input .highlow.fourpointslider2 .ui-slider-range { */
      /*  background: #9966ff; */
      /*}*/
      /*.fourpointslider-input .highlow.fourpointslider3 .ui-slider-range { */
      /*  background: #800080; */
      /*}*/
      /*.fourpointslider-input .highlow.fourpointslider4 .ui-slider-range { */
      /*  background: #f4c441; */
      /*}*/
      /*.fourpointslider-input .highlow.fourpointslider5 .ui-slider-range { */
      /*  background: #f46d41; */
      /*}*/
      /*.fourpointslider-input .highlow.fourpointslider6 .ui-slider-range { */
      /*  background: #f44141; */
      /*}*/
      /*.fourpointslider-input .highlow.fourpointslider7 .ui-slider-range { */
      /*  background: #f441a6; */
      /*}*/
      .fourpointslider-input  > span > .sliderpod > .fourpointslider-vertical > .highlow > .ui-slider-handle { 
        border-color: #729fcf; 
        border-radius: 0.1em;
        width: 1.25em;
        height:0.4em;
        margin-bottom: -.3em;
      }
      .fourpointslider-input  > span > .sliderpod {
          float:left;
          margin-top:10px;
          margin-bottom:20px;
          padding: 0em 1.5em;
      }
      .fourpointslider-input p {
          margin:0px;
      }
      .fourpointslider-vertical-axis p {
          margin:0px;
      }

      .fourpointslider-vertical-ylab {
          margin: 0px 0px 0px 16px;
          float: left;
          width: 3em;
      }

      .fourpointslider-vertical-ylab p {
          -ms-transform: rotate(270deg); /* IE 9 */
          -webkit-transform: rotate(270deg); /* Safari 3-8 */
          transform: rotate(270deg);
          margin: 0;
          text-align: center;
      }
    </style>


    <div class="container-fluid">
      <h2 style="text-align:center;">Input Sliders For Expert Elicitation</h2>
      <div class="row">
        <div class="col-sm-6" style="min-width:900px;">
          <p class="text-bold">4-point elicitation with repeating grouped categories: Each element on the x-axis contains any number of sub-elements (provided all elements have the same number of sub-elements).</p>
          <p class="text-bold">Default colors are a blue gradient. The ML cannot move beyond the H or L and vice-versa.</p>
          <div id="byGate" type="fourpointslider" style="" class="fourpointslider-input">
            <table>
              <tr>
                <td style="padding:0em 1em 0em 7em;">Upper basin</td>
                <td>
                  <div style="padding:8px;height:1em;width:3em;background-color:#0044B2;"></div>
                </td>
              </tr>
              <tr>
                <td style="padding:0em 1em 0em 7em;">Middle basin</td>
                <td>
                  <div style="padding:8px;height:1em;width:3em;background-color:#638DD2;"></div>
                </td>
              </tr>
              <tr>
                <td style="padding:0em 1em 0em 7em;">Lower basin</td>
                <td>
                  <div style="padding:8px;height:1em;width:3em;background-color:#C6D7F2;"></div>
                </td>
              </tr>
            </table>
            <style>#byGate .highlow.fourpointslider0 .ui-slider-range {background: #0044B2;}
    #byGate .highlow.fourpointslider1 .ui-slider-range {background: #638DD2;}
    #byGate .highlow.fourpointslider2 .ui-slider-range {background: #C6D7F2;}</style>
            <div class="fourpointslider-vertical-ylab" style="height:400px;">
              <p style="height:400px;width:400px;">Custom Scale Of Elicitation, values</p>
            </div>
            <div class="fourpointslider-vertical-axis" style="height:400px;">
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>500</p>
              </div>
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>400</p>
              </div>
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>300</p>
              </div>
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>200</p>
              </div>
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>100</p>
              </div>
              <div style="padding:0px 10px;text-align:right;">
                <p>0</p>
              </div>
            </div>
            <span style="width:9.6em;min-width:6em;">
              <span class="sliderpod" style="height:400px;width:9.6em;min-width:6em;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;border-left:1px solid #ddd;">
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow0_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">200,300</span>
                  <span id="byGateml0_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">250</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow0_1" class="highlow fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">100,200</span>
                  <span id="byGateml0_1" class="ml fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">150</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow0_2" class="highlow fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">85,185</span>
                  <span id="byGateml0_2" class="ml fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">125</span>
                </span>
              </span>
              <p class="x-axislabel">Gate Setting 1</p>
              <p style="text-align:center;">
                <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
              </p>
            </span>
            <span style="width:9.6em;min-width:6em;">
              <span class="sliderpod" style="height:400px;width:9.6em;min-width:6em;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow1_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">125,200</span>
                  <span id="byGateml1_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">150</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow1_1" class="highlow fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">50,350</span>
                  <span id="byGateml1_1" class="ml fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">250</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow1_2" class="highlow fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">250,450</span>
                  <span id="byGateml1_2" class="ml fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">350</span>
                </span>
              </span>
              <p class="x-axislabel">Gate Setting 2</p>
              <p style="text-align:center;">
                <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
              </p>
            </span>
            <span style="width:9.6em;min-width:6em;">
              <span class="sliderpod" style="height:400px;width:9.6em;min-width:6em;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow2_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">225,500</span>
                  <span id="byGateml2_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">450</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow2_1" class="highlow fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">250,450</span>
                  <span id="byGateml2_1" class="ml fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">350</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow2_2" class="highlow fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">250,350</span>
                  <span id="byGateml2_2" class="ml fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">300</span>
                </span>
              </span>
              <p class="x-axislabel">Gate Setting 3</p>
              <p style="text-align:center;">
                <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
              </p>
            </span>
            <span style="width:9.6em;min-width:6em;">
              <span class="sliderpod" style="height:400px;width:9.6em;min-width:6em;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow3_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">125,200</span>
                  <span id="byGateml3_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">150</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow3_1" class="highlow fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">50,350</span>
                  <span id="byGateml3_1" class="ml fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">250</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow3_2" class="highlow fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">250,450</span>
                  <span id="byGateml3_2" class="ml fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">350</span>
                </span>
              </span>
              <p class="x-axislabel">Gate Setting 4</p>
              <p style="text-align:center;">
                <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
              </p>
            </span>
            <span style="width:9.6em;min-width:6em;">
              <span class="sliderpod" style="height:400px;width:9.6em;min-width:6em;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;border-right:1px solid #ddd;">
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow4_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">25,100</span>
                  <span id="byGateml4_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Upper basin">85</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow4_1" class="highlow fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">50,150</span>
                  <span id="byGateml4_1" class="ml fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Middle basin">125</span>
                </span>
                <span class="fourpointslider-vertical">
                  <span id="byGatehighlow4_2" class="highlow fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">100,125</span>
                  <span id="byGateml4_2" class="ml fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Lower basin">110</span>
                </span>
              </span>
              <p class="x-axislabel">Gate Setting 5</p>
              <p style="text-align:center;">
                <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
              </p>
            </span>
            <script type="text/javascript">fourpointslider( '#byGate' );</script>
          </div>
        </div>
        <div class="col-sm-6" style="min-width:900px;">
          <div class="well" style="overflow:hidden;">
            <p class="text-bold">Sliders can be disabled programmatically. Customize colors by setting either a custom gradient or discrete values.</p>
            <div id="byBasin" type="fourpointslider" style="" class="fourpointslider-input">
              <table>
                <tr>
                  <td style="padding:0em 1em 0em 7em;">Gate Setting 1</td>
                  <td>
                    <div style="padding:8px;height:1em;width:3em;background-color:#FF0000;"></div>
                  </td>
                </tr>
                <tr>
                  <td style="padding:0em 1em 0em 7em;">Gate Setting 2</td>
                  <td>
                    <div style="padding:8px;height:1em;width:3em;background-color:#FFA500;"></div>
                  </td>
                </tr>
                <tr>
                  <td style="padding:0em 1em 0em 7em;">Gate Setting 3</td>
                  <td>
                    <div style="padding:8px;height:1em;width:3em;background-color:#FFFF00;"></div>
                  </td>
                </tr>
                <tr>
                  <td style="padding:0em 1em 0em 7em;">Gate Setting 4</td>
                  <td>
                    <div style="padding:8px;height:1em;width:3em;background-color:#00FF00;"></div>
                  </td>
                </tr>
                <tr>
                  <td style="padding:0em 1em 0em 7em;">Gate Setting 5</td>
                  <td>
                    <div style="padding:8px;height:1em;width:3em;background-color:#0000FF;"></div>
                  </td>
                </tr>
              </table>
              <style>#byBasin .highlow.fourpointslider0 .ui-slider-range {background: #FF0000;}
    #byBasin .highlow.fourpointslider1 .ui-slider-range {background: #FFA500;}
    #byBasin .highlow.fourpointslider2 .ui-slider-range {background: #FFFF00;}
    #byBasin .highlow.fourpointslider3 .ui-slider-range {background: #00FF00;}
    #byBasin .highlow.fourpointslider4 .ui-slider-range {background: #0000FF;}</style>
              <div class="fourpointslider-vertical-ylab" style="height:400px;">
                <p style="height:400px;width:400px;">Custom Scale Of Elicitation, values</p>
              </div>
              <div class="fourpointslider-vertical-axis" style="height:400px;">
                <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                  <p>500</p>
                </div>
                <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                  <p>400</p>
                </div>
                <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                  <p>300</p>
                </div>
                <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                  <p>200</p>
                </div>
                <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                  <p>100</p>
                </div>
                <div style="padding:0px 10px;text-align:right;">
                  <p>0</p>
                </div>
              </div>
              <span style="width:16em;min-width:6em;">
                <span class="sliderpod" style="height:400px;width:16em;min-width:6em;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #fff 1px, #fff 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;border-left:1px solid #ddd;">
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow0_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="1" data-name="Gate Setting 1">200,300</span>
                    <span id="byBasinml0_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="1" data-name="Gate Setting 1">250</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow0_1" class="highlow fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 2">125,200</span>
                    <span id="byBasinml0_1" class="ml fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 2">150</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow0_2" class="highlow fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 3">225,500</span>
                    <span id="byBasinml0_2" class="ml fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 3">450</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow0_3" class="highlow fourpointslider3" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 4">125,200</span>
                    <span id="byBasinml0_3" class="ml fourpointslider3" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 4">150</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow0_4" class="highlow fourpointslider4" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 5">25,100</span>
                    <span id="byBasinml0_4" class="ml fourpointslider4" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 5">85</span>
                  </span>
                </span>
                <p class="x-axislabel">Upper basin</p>
                <p style="text-align:center;">
                  <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
                </p>
              </span>
              <span style="width:16em;min-width:6em;">
                <span class="sliderpod" style="height:400px;width:16em;min-width:6em;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #fff 1px, #fff 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow1_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 1">100,200</span>
                    <span id="byBasinml1_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 1">150</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow1_1" class="highlow fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 2">50,350</span>
                    <span id="byBasinml1_1" class="ml fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 2">250</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow1_2" class="highlow fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 3">250,450</span>
                    <span id="byBasinml1_2" class="ml fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 3">350</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow1_3" class="highlow fourpointslider3" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 4">50,350</span>
                    <span id="byBasinml1_3" class="ml fourpointslider3" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 4">250</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow1_4" class="highlow fourpointslider4" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 5">50,150</span>
                    <span id="byBasinml1_4" class="ml fourpointslider4" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 5">125</span>
                  </span>
                </span>
                <p class="x-axislabel">Middle basin</p>
                <p style="text-align:center;">
                  <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
                </p>
              </span>
              <span style="width:16em;min-width:6em;">
                <span class="sliderpod" style="height:400px;width:16em;min-width:6em;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #fff 1px, #fff 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;border-right:1px solid #ddd;">
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow2_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 1">85,185</span>
                    <span id="byBasinml2_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 1">125</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow2_1" class="highlow fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 2">250,450</span>
                    <span id="byBasinml2_1" class="ml fourpointslider1" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 2">350</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow2_2" class="highlow fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 3">250,350</span>
                    <span id="byBasinml2_2" class="ml fourpointslider2" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 3">300</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow2_3" class="highlow fourpointslider3" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 4">250,450</span>
                    <span id="byBasinml2_3" class="ml fourpointslider3" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 4">350</span>
                  </span>
                  <span class="fourpointslider-vertical">
                    <span id="byBasinhighlow2_4" class="highlow fourpointslider4" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 5">100,125</span>
                    <span id="byBasinml2_4" class="ml fourpointslider4" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 5">110</span>
                  </span>
                </span>
                <p class="x-axislabel">Lower basin</p>
                <p style="text-align:center;">
                  <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
                </p>
              </span>
              <script type="text/javascript">fourpointslider( '#byBasin' );</script>
            </div>
          </div>
        </div>
        <div class="col-sm-6" style="min-width:900px;">
          <p class="text-bold">Single sliders per group. Turn background lines off for a cleaner look.</p>
          <div id="singles" type="fourpointslider" style="" class="fourpointslider-input">
            <style>#singles .highlow.fourpointslider0 .ui-slider-range {background: #0044B2;}</style>
            <div class="fourpointslider-vertical-ylab" style="height:400px;">
              <p style="height:400px;width:400px;">Custom Scale Of Elicitation, values</p>
            </div>
            <div class="fourpointslider-vertical-axis" style="height:400px;">
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>500</p>
              </div>
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>400</p>
              </div>
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>300</p>
              </div>
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>200</p>
              </div>
              <div class="tick" style="height: 80px;padding-right:10px;text-align:right;">
                <p>100</p>
              </div>
              <div style="padding:0px 10px;text-align:right;">
                <p>0</p>
              </div>
            </div>
            <span style="width:3.2em;min-width:6em;">
              <span class="sliderpod" style="height:400px;width:3.2em;min-width:6em;background:#00000000;border-top:1px solid #ddd;border-bottom:1px solid #ddd;border-left:1px solid #ddd;">
                <span class="fourpointslider-vertical">
                  <span id="singleshighlow0_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="1" data-name="Gate Setting 1">200,300</span>
                  <span id="singlesml0_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="1" data-name="Gate Setting 1">250</span>
                </span>
              </span>
              <p class="x-axislabel">Upper basin (disabled)</p>
              <p style="text-align:center;">
                <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
              </p>
            </span>
            <span style="width:3.2em;min-width:6em;">
              <span class="sliderpod" style="height:400px;width:3.2em;min-width:6em;background:#00000000;border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
                <span class="fourpointslider-vertical">
                  <span id="singleshighlow1_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 1">100,200</span>
                  <span id="singlesml1_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 1">150</span>
                </span>
              </span>
              <p class="x-axislabel">Middle basin</p>
              <p style="text-align:center;">
                <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
              </p>
            </span>
            <span style="width:3.2em;min-width:6em;">
              <span class="sliderpod" style="height:400px;width:3.2em;min-width:6em;background:#00000000;border-top:1px solid #ddd;border-bottom:1px solid #ddd;border-right:1px solid #ddd;">
                <span class="fourpointslider-vertical">
                  <span id="singleshighlow2_0" class="highlow fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 1">85,185</span>
                  <span id="singlesml2_0" class="ml fourpointslider0" style="height:400px;" data-min="0" data-max="500" data-step="1" data-disabled="FALSE" data-name="Gate Setting 1">125</span>
                </span>
              </span>
              <p class="x-axislabel">Lower basin</p>
              <p style="text-align:center;">
                <input style="text-align:center;" type="text" placeholder="Conf: 50-100%"/>
              </p>
            </span>
            <script type="text/javascript">fourpointslider( '#singles' );</script>
          </div>
        </div>
        <div class="col-sm-6" style="min-width:900px;">
          <div class="well" style="overflow:hidden;">
            <p class="text-bold">3-point elicitation sliders are linked to a numeric display. Backgrounds can be either white or transparent.</p>
            <div id="threepointers" type="threepointslider" style="display:inline-flex;" class="form-group shiny-input-container threepointslider">
              <style>#threepointers .highlow .ui-slider-range {background: #0044b2;}</style>
              <div class="threepointslider-vertical-ylab" style="height:300px;">
                <p style="height:300px;width:300px;">A small scale (numbers)</p>
              </div>
              <div class="threepointslider-vertical-axis">
                <div class="tick" style="height: 60px;padding-right:10px;text-align:right;">
                  <p>5</p>
                </div>
                <div class="tick" style="height: 60px;padding-right:10px;text-align:right;">
                  <p>4</p>
                </div>
                <div class="tick" style="height: 60px;padding-right:10px;text-align:right;">
                  <p>3</p>
                </div>
                <div class="tick" style="height: 60px;padding-right:10px;text-align:right;">
                  <p>2</p>
                </div>
                <div class="tick" style="height: 60px;padding-right:10px;text-align:right;">
                  <p>1</p>
                </div>
                <div style="padding-right:10px;text-align:right;">
                  <p>0</p>
                </div>
              </div>
              <span>
                <span class="threepointslider-vertical" style="width:6.5em;height:300px;margin-top:10px;margin-bottom:20px;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;border-left:1px solid #ddd;">
                  <span id="threepointershighlow0" class="highlow" style="height:300px;" data-min="0" data-max="5" data-step="0.1" data-disabled>2,3</span>
                  <span id="threepointersml0" class="ml" style="height:300px;" data-min="0" data-max="5" data-step="0.1" data-disabled>2.5</span>
                </span>
                <p class="x-axislabel">slider1</p>
                <p>
                  <p style="padding-left:1em;display:inline;">H:</p>
                  <p class="hlabel0" id="threepointershlabel0" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
                <p>
                  <p style="padding-left:1em;display:inline;">L:</p>
                  <p class="llabel0" id="threepointersllabel0" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
                <p>
                  <p style="display:inline;">ML:</p>
                  <p class="mllabel0" id="threepointersmllabel0" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
              </span>
              <span>
                <span class="threepointslider-vertical" style="width:6.5em;height:300px;margin-top:10px;margin-bottom:20px;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
                  <span id="threepointershighlow1" class="highlow" style="height:300px;" data-min="0" data-max="5" data-step="0.1" data-disabled="1">1,2</span>
                  <span id="threepointersml1" class="ml" style="height:300px;" data-min="0" data-max="5" data-step="0.1" data-disabled="1">1.5</span>
                </span>
                <p class="x-axislabel">A disabled slider</p>
                <p>
                  <p style="padding-left:1em;display:inline;">H:</p>
                  <p class="hlabel1" id="threepointershlabel1" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
                <p>
                  <p style="padding-left:1em;display:inline;">L:</p>
                  <p class="llabel1" id="threepointersllabel1" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
                <p>
                  <p style="display:inline;">ML:</p>
                  <p class="mllabel1" id="threepointersmllabel1" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
              </span>
              <span>
                <span class="threepointslider-vertical" style="width:6.5em;height:300px;margin-top:10px;margin-bottom:20px;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
                  <span id="threepointershighlow2" class="highlow" style="height:300px;" data-min="0" data-max="5" data-step="0.1" data-disabled>2,5</span>
                  <span id="threepointersml2" class="ml" style="height:300px;" data-min="0" data-max="5" data-step="0.1" data-disabled>4</span>
                </span>
                <p class="x-axislabel">slider3</p>
                <p>
                  <p style="padding-left:1em;display:inline;">H:</p>
                  <p class="hlabel2" id="threepointershlabel2" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
                <p>
                  <p style="padding-left:1em;display:inline;">L:</p>
                  <p class="llabel2" id="threepointersllabel2" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
                <p>
                  <p style="display:inline;">ML:</p>
                  <p class="mllabel2" id="threepointersmllabel2" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
              </span>
              <span>
                <span class="threepointslider-vertical" style="width:6.5em;height:300px;margin-top:10px;margin-bottom:20px;background: repeating-linear-gradient(to bottom, #ddd, #ddd 1px, #00000000 1px, #00000000 10%);border-top:1px solid #ddd;border-bottom:1px solid #ddd;border-right:1px solid #ddd;">
                  <span id="threepointershighlow3" class="highlow" style="height:300px;" data-min="0" data-max="5" data-step="0.1" data-disabled>2.5,3</span>
                  <span id="threepointersml3" class="ml" style="height:300px;" data-min="0" data-max="5" data-step="0.1" data-disabled>2.75</span>
                </span>
                <p class="x-axislabel">slider4</p>
                <p>
                  <p style="padding-left:1em;display:inline;">H:</p>
                  <p class="hlabel3" id="threepointershlabel3" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
                <p>
                  <p style="padding-left:1em;display:inline;">L:</p>
                  <p class="llabel3" id="threepointersllabel3" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
                <p>
                  <p style="display:inline;">ML:</p>
                  <p class="mllabel3" id="threepointersmllabel3" style="display:inline; color:#f6931f; font-weight:bold;"></p>
                </p>
              </span>
              <script type="text/javascript">threepointslider( '#threepointers' );</script>
            </div>
          </div>
        </div>
        <div style="min-height:200px;"></div>
      </div>
    </div>

