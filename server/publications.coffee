Meteor.publish 'lights', ->
  if @userId then Light.find() else []

Meteor.publish 'timers', ->
  if @userId then Timer.find() else []

Meteor.publish 'presets', ->
  if @userId then Preset.find() else []
