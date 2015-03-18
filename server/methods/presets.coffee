Meteor.methods
  insertPreset: (name) ->
    states = availableLights()

    lights = _.map states, (data, id) ->
      id: id
      data:
        hue: data.state.hue
        bri: data.state.bri
        sat: data.state.sat

    Preset.insert(name: name, lights: lights)

  syncWithBridge: ->
    res = HTTP.get("#{Meteor.settings.url}scenes")
    bridge_presets = res.data

    Preset.find().forEach (p) ->
      unless bridge_presets[p.name]
        console.log(HTTP.put "#{Meteor.settings.url}scenes/#{p._id}", data:
          lights: _.pluck(p.lights, 'id'))
      _.each p.lights, (l) ->
        console.log(HTTP.put "#{Meteor.settings.url}scenes/#{p._id}/lights/#{l.id}/state",
          data: l.data)

availableLights = ->
  res = HTTP.get("#{Meteor.settings.url}lights")
  states = JSON.parse(res.content)
  _.each states, (v, k) ->
    delete states[k] unless v.state.reachable && v.state.on # only reachable lights
  states
