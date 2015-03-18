running = false
currentLightIndex = 0
availableLights = []

Template.dashboard.created = ->
  Session.set('steps', [])

  # get available lights
  this.autorun ->
    return unless Session.get('url')

    res = HTTP.get("#{Session.get('url')}lights", null, (err, res) ->
      states = JSON.parse(res.content)
      ids = []
      states = _.each states, (d, id) ->
        if d.state.reachable && d.state.on
          ids.push(id)
      availableLights = Light.find(id: $in: ids).fetch()
    )

Template.dashboard.rendered = ->
  $('#hue-slider').noUiSlider
    start: [0, 65535]
    range:
      min: 0
      max: 65535
    connect: true
    format: wNumb
      decimals: 0

  $('#bri-slider').noUiSlider
    start: [0, 255]
    range:
      min: 0
      max: 255
    connect: true
    format: wNumb
      decimals: 0

  $('#sat-slider').noUiSlider
    start: [0, 255]
    range:
      min: 0
      max: 255
    connect: true
    format: wNumb
      decimals: 0

  $('#transitiontime-slider').noUiSlider
    start: 4
    connect: 'lower'
    step: 1
    range:
      min: 0
      max: 20
    format: wNumb
      decimals: 0


  $('#hue-slider').Link('lower').to($('#hue-display-lower'))
  $('#hue-slider').Link('upper').to($('#hue-display-upper'))
  $('#bri-slider').Link('lower').to($('#bri-display-lower'))
  $('#bri-slider').Link('upper').to($('#bri-display-upper'))
  $('#sat-slider').Link('lower').to($('#sat-display-lower'))
  $('#sat-slider').Link('upper').to($('#sat-display-upper'))
  $('#transitiontime-slider').Link('lower').
    to($('#transitiontime-display'))

Template.dashboard.helpers
  steps: ->
    Session.get('steps')
  startDisabled: ->
    Session.get('steps').length == 0
  presets: ->
    Preset.find()

# Events
Template.dashboard.events
  'click button.add': ->
    steps = Session.get('steps')
    steps.push(
      hue: $('#hue-slider').val()
      bri: $('#bri-slider').val()
      sat: $('#sat-slider').val()
      transitiontime: $('#transitiontime-slider').val()
    )
    Session.set('steps', steps)

  'click button.start': ->
    running = true
    handleStep(0)

  'click button.stop': ->
    running = false
    LightModel.restore()

# Helpers
handleStep = (current) ->
  return unless running

  console.log("handling step ##{current}")
  steps = Session.get('steps')
  step = steps[current]

  if $('#synchronize-colors').prop('checked')
    LightModel.changeAll(stepData(step))
  else
    if $('#synchronize-timing').prop('checked')
      _.each(availableLights, (light) ->
        light.change(stepData(step))
      )
    else
      availableLights[currentLightIndex].change(stepData(step))
      currentLightIndex = (currentLightIndex + 1) % availableLights.length

  Meteor.setTimeout(
    -> handleStep((current + 1) % steps.length)
    1000
  )

stepData = (step) ->
  hue: randomValue(step.hue)
  bri: randomValue(step.bri)
  sat: randomValue(step.sat)
  transitiontime: Number(step.transitiontime)

randomValue = ([min, max]) ->
  min = Number(min)
  max = Number(max)+1
  Math.floor(Math.random() * (max-min) + min)
