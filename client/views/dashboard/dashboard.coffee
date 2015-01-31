running = false

Template.dashboard.created = ->
  Session.set('steps', [])

Template.dashboard.rendered = ->
  $('#hue-slider').noUiSlider
    start: [0, 65535]
    range:
        min: 0
        max: 65535
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

Template.dashboard.helpers
  steps: ->
    Session.get('steps')
  startDisabled: ->
    Session.get('steps').length == 0

# Events
Template.dashboard.events
  'click button.add': ->
    steps = Session.get('steps')
    steps.push(
      hue: $('#hue-slider').val()
      bri: $('#bri-slider').val()
      sat: $('#sat-slider').val()
    )
    Session.set('steps', steps)

  'click button.start': ->
    running = true
    handleStep(0)

  'click button.stop': ->
    running = false

handleStep = (current) ->
  return unless running

  console.log("handling step ##{current}")
  steps = Session.get('steps')
  step = steps[current]
  data =
    hue: randomValue(step.hue)
    bri: randomValue(step.bri)
    sat: randomValue(step.sat)
  LightModel.changeAll(data)

  Meteor.setTimeout(
    -> handleStep((current + 1) % steps.length)
    1000
  )

randomValue = ([min, max]) ->
  min = Number(min)
  max = Number(max)+1
  Math.floor(Math.random() * (max-min) + min)
