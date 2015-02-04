Meteor.methods
  insertPreset: (name) ->
    res = HTTP.get("#{Meteor.settings.url}lights")
    states = JSON.parse(res.content)
    states = _.filter states, (d) ->
      d.state.reachable && d.state.on # only reachable lights

    lights = _.map states, (data, id) ->
      id: id
      data:
        hue: data.state.hue
        bri: data.state.bri
        sat: data.state.sat

    Preset.insert(name: name, lights: lights)
