Meteor.subscribe('lights')

Template.lightsIndex.helpers
  lights: ->
    Light.find()

Template.lightsIndex.events
  'click button.on': ->
    this.change(on: true)
  'click button.off': ->
    this.change(on: false)
  'click button.default': ->
    this.restore()

  'click button.allOn': ->
    LightModel.changeAll(on: true)
  'click button.allOff': ->
    LightModel.changeAll(on: false)
  'click button.allDefault': ->
    LightModel.restore()

  'click button.edit': ->
    Router.go('lights.edit', _id: @_id)
