return unless Meteor.isClient

this.changeLights = ->
  LightModel.changeAll
    hue: Math.floor(Math.random() * 65536)
    bri: 255
    sat: 255
    transitiontime: 0
this.changeLights = _.throttle(this.changeLights, 1000)


this.createAudioMeter = (audioContext) ->
  processor = audioContext.createScriptProcessor(256)
  processor.lastClip = 0

  processor.connect(audioContext.destination)

  processor.onaudioprocess = (e, a) ->
    if Math.abs(e.inputBuffer.getChannelData(0)[0]) > 0.5
      if (@lastClip + 500) < window.performance.now()
        @lastClip = window.performance.now()
        changeLights()

  # ?
  processor.shutdown = ->
    console.log('shutdown called')
    this.disconnect()
    this.onaudioprocess = null

  return processor


gotStream = (stream) ->
  console.log('gotstream')
  a = new AudioContext()
  source = a.createMediaStreamSource(stream)
  window.meter = createAudioMeter(a)
  source.connect(meter)
  check()

Meteor.startup ->
  navigator.webkitGetUserMedia
    audio: true
    gotStream
    (e) ->
      throw(e)

# throw
# console.log('errrr')
# console.log(e)


# return unless Meteor.isClient
#
# # this.createAudioMeter = (audioContext, clipLevel = 0.98, averaging = 0.95,
# this.createAudioMeter = (audioContext, clipLevel = 0.5, averaging = 0.95,
#                          clipLag = 750) ->
#   processor = audioContext.createScriptProcessor(512)
#   processor.onaudioprocess = volumeAudioProcess
#   processor.clipping = false
#   processor.lastClip = 0
#   processor.volume = 0
#   processor.clipLevel = clipLevel
#   processor.averaging = averaging
#   processor.clipLag = clipLag
#
# 	# this will have no effect, since we don't copy the input to the output,
#   # but works around a current Chrome bug.
#   processor.connect(audioContext.destination)
#
#   processor.checkClipping = ->
#     if (!this.clipping)
#       return false
#     if ((this.lastClip + this.clipLag) < window.performance.now())
#       this.clipping = false
#     return this.clipping
#
#   processor.shutdown = ->
#     this.disconnect()
#     this.onaudioprocess = null
#
#   return processor
#
#
# volumeAudioProcess = (event) ->
#   buf = event.inputBuffer.getChannelData(0)
#   sum = 0
#
#   # Do a root-mean-square on the samples: sum up the squares...
#   for x in buf
#     if (Math.abs(x)>=this.clipLevel)
#       this.clipping = true
#       this.lastClip = window.performance.now()
#
#     sum += x * x
#
#     # ... then take the square root of the sum.
#     rms =  Math.sqrt(sum / buf.length)
#
#     # Now smooth this out with the averaging factor applied
#     # to the previous sample - take the max here because we
#     # want "fast attack, slow release."
#     this.volume = Math.max(rms, this.volume*this.averaging)
#
# gotStream = (stream) ->
#   console.log('gotstream')
#   a = new AudioContext()
#   source = a.createMediaStreamSource(stream)
#   window.meter = createAudioMeter(a)
#   source.connect(meter)
#   check()
#
# navigator.webkitGetUserMedia
#   audio:
#     mandatory:
#       googEchoCancellation: false
#       googAutoGainControl: false
#       googNoiseSuppression: false
#       googHighpassFilter: false
#     optional: []
#   gotStream
#   ->
#     console.log('errrr')
#
# Meteor.startup ->
#   window.running = true
#   l = true
#   clipping = false
#   window.check = ->
#     if meter.checkClipping()
#       unless clipping
#         l = !l
#         if l
#           # LightModel.changeAll(on: true, transitiontime: 5, bri: 254)
#           LightModel.changeAll(hue: 0, sat: 255, transitiontime: 0, bri: 254)
#         else
#           LightModel.restore()
#       clipping = true
#     else
#       # console.log('nope')
#       clipping = false
#     if running
#       setTimeout(check, 100)
