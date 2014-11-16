Meteor.subscribe('lights')

Template.lights.helpers
  lights: ->
    Light.find().fetch()

Template.lights.events
  'click button.on': (e) ->
    this.change(on: true)
  'click button.off': (e) ->
    this.change(on: false)
