Meteor.subscribe('presets')

Template.presetsIndex.helpers
  presets: ->
    Preset.find()

Template.presetsIndex.events
  'click .addPreset': (e) ->
    Meteor.call('insertPreset', 'newPreset')
