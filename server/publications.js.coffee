Meteor.publish 'lights', ->
  Light.find()

Meteor.publish 'timers', ->
  Timer.find()
