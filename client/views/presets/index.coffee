Meteor.subscribe('presets')

Template.presetsIndex.helpers
  presets: ->
    Preset.find()
  hsl: (data) ->
    hue = data.hue / 65535 * 360
    bri = data.bri / 255 * 100
    sat = data.sat / 255 * 100
    tinycolor(h: hue, s: sat, v: bri).toHexString()

Template.presetsIndex.events
  'click .addPreset': (e) ->
    Meteor.call('insertPreset', 'newPreset')

  'click .select': (e) ->
    HTTP.put "#{Session.get('url')}groups/0/action", data: scene: @_id, ->

  'click .default': (e) ->
    LightModel.restore()

  'click .sync': (e) ->
    Meteor.call('syncWithBridge')
