# Collection
@Preset = new Meteor.Collection 'presets'

# Schema
@Preset.attachSchema new SimpleSchema
  name:
    type: String
    label: 'Name'

  lights:
    type: [Object]
  'lights.$.id':
    type: String
  'lights.$.data':
    type: Object
  'lights.$.data.hue':
    type: Number
  'lights.$.data.sat':
    type: Number
  'lights.$.data.bri':
    type: Number

# Allow update
@Preset.allow
  insert: ->
    true
