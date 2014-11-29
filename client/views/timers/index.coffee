Meteor.subscribe('timers')

Template.timersIndex.helpers
  timers: ->
    Timer.find()
  lights: ->
    Light.find(_id: $in: this.lights)

Template.timersIndex.events
  'click button.edit': ->
    Router.go('timers.edit', _id: @_id)
