Meteor.subscribe('lights')

Template.lightsIndex.helpers
  lights: ->
    Light.find()

Template.lightsIndex.events
  'click button.on': (e) ->
    this.change(on: true)
  'click button.off': (e) ->
    this.change(on: false)
