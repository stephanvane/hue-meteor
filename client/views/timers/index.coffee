Meteor.subscribe('timers')

Template.timersIndex.helpers
  timers: ->
    Timer.find()
