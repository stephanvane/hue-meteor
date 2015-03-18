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
    # Meteor.call('insertPreset', $('.name').val())
    HTTP.get "#{Session.get('url')}lights", (_err, res) ->
      states = JSON.parse(res.content)
      states = _.filter states, (d) ->
        d.state.reachable && d.state.on # only reachable lights

      lights = _.map states, (data, id) ->
        id: id
        data:
          hue: data.state.hue
          bri: data.state.bri
          sat: data.state.sat

      Preset.insert name: $('.name').val(), lights: lights, (err) ->
        console.log("error: #{err}") if err

  'click .delete': (e) ->
    Preset.remove(@_id)
