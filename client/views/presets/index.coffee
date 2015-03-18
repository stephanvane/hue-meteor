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
    Meteor.call('insertPreset', $('.name').val())

  'click .select': (e) ->
    HTTP.put "#{Session.get('url')}groups/0/action", data: scene: @name, ->

  'click .default': (e) ->
    LightModel.restore()

  'click .sync': (e) ->
    Meteor.call('syncWithBridge')

  'click .delete': (e) ->
    Preset.remove(@_id)
