Template.dashboard.rendered = ->
  $('#hue-slider').noUiSlider
    start: [0, 255]
    range:
        min: 0
        max: 255
    connect: true

  $('#bri-slider').noUiSlider
    start: [0, 255]
    range:
        min: 0
        max: 255
    connect: true

  $('#sat-slider').noUiSlider
    start: [0, 255]
    range:
        min: 0
        max: 255
    connect: true


  $('#hue-slider').Link('lower').to($('#hue-display-lower'))
  $('#hue-slider').Link('upper').to($('#hue-display-upper'))
  $('#bri-slider').Link('lower').to($('#bri-display-lower'))
  $('#bri-slider').Link('upper').to($('#bri-display-upper'))
  $('#sat-slider').Link('lower').to($('#sat-display-lower'))
  $('#sat-slider').Link('upper').to($('#sat-display-upper'))