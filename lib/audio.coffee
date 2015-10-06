return unless Meteor.isClient

this.changeLights = ->
  LightModel.changeAll
    hue: Math.floor(Math.random() * 65536)
    bri: 90
    sat: 255
    transitiontime: 0
this.changeLights = _.throttle(this.changeLights, 1000)


this.createAudioMeter = (audioContext) ->
  processor = audioContext.createScriptProcessor(256)
  processor.lastClip = 0


  processor.connect(audioContext.destination)

  processor.onaudioprocess = (e, a) ->
    c = autoCorrelate(e.inputBuffer.getChannelData(0), audioContext.sampleRate)
    if c != -1 && (@lastClip + 500) < window.performance.now()
      @lastClip = window.performance.now()
      bri = Math.floor(Math.min(Math.max((c - 800), 0), 1200) / 1200 * 255)
      console.log("bri = #{bri}")
      LightModel.changeAll(bri: bri)

    # REENABLE THIS
    # if Math.abs(e.inputBuffer.getChannelData(0)[0]) > 0.5
    #   if (@lastClip + 500) < window.performance.now()
    #     @lastClip = window.performance.now()
    #     changeLights()

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

# https://github.com/cwilso/PitchDetect/blob/master/js/pitchdetect.js
MIN_SAMPLES = 0  # will be initialized when AudioContext is created.

autoCorrelate = (buf, sampleRate) ->
  SIZE = buf.length
  MAX_SAMPLES = Math.floor(SIZE/2)
  best_offset = -1
  best_correlation = 0
  rms = 0
  foundGoodCorrelation = false
  correlations = new Array(MAX_SAMPLES)

  for i in [0...SIZE]
    val = buf[i]
    rms += val*val

  rms = Math.sqrt(rms/SIZE)
  # if (rms<0.01) # not enough signal
  if (rms<0.02) # not enough signal
    return -1

  lastCorrelation=1
  for offset in [MIN_SAMPLES...MAX_SAMPLES]
    correlation = 0

    for i in [0...MAX_SAMPLES]
      correlation += Math.abs((buf[i])-(buf[i+offset]))

    correlation = 1 - (correlation/MAX_SAMPLES)
    # store it, for the tweaking we need to do below.
    correlations[offset] = correlation

    if ((correlation>0.9) && (correlation > lastCorrelation))
      foundGoodCorrelation = true
      if (correlation > best_correlation)
        best_correlation = correlation
        best_offset = offset
    else if (foundGoodCorrelation)
      # short-circuit - we found a good correlation, then a bad one, so we'd
      # just be seeing copies from here. Now we need to tweak the offset - by
      # interpolating between the values to the left and right of the best
      # offset, and shifting it a bit.  This is complex, and HACKY in this code
      # (happy to take PRs!) - we need to do a curve fit on correlations[]
      # around best_offset in order to better determine precise (anti-aliased)
      # offset.

      # we know best_offset >=1,
      # since foundGoodCorrelation cannot go to true until the second pass
      # (offset=1), and we can't drop into this clause until the following pass
      # (else if).
      shift = (correlations[best_offset+1] - correlations[best_offset-1])/correlations[best_offset]
      return sampleRate/(best_offset+(8*shift))

    lastCorrelation = correlation;

  if (best_correlation > 0.01)
    console.log("f = #{sampleRate/best_offset} Hz (rms: #{rms} confidence: #{best_correlation})")
    return sampleRate/best_offset
  return -1

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
#   # this will have no effect, since we don't copy the input to the output,
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
