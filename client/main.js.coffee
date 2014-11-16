Meteor.subscribe('lights')

Template.lights.helpers
  lights: ->
    Light.find().fetch()
