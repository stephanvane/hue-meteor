# Collection
@Timer = new Meteor.Collection 'timers'

# Schema
@Timer.attachSchema new SimpleSchema
  name:
    type: String
    label: 'Name'

  lights:
    type: [String]
    label: 'Lights'
    regEx: SimpleSchema.RegEx.Id
    autoform:
      options: ->
        Light.find().map((l) -> { label: l.name, value: l._id })

  schedule:
    type: String
    label: 'Schedule'

# Allow update
@Timer.allow
  update: ->
    true

# Callbacks
@Timer.after.update ->
  if Meteor.isServer
    SyncedCron.stop()
    Timer.find().forEach (t) ->
      SyncedCron.add
        name: t.name
        schedule: (parser) -> parser.text(t.schedule)
        job: ->
          LightModel.changeAll(t.data)
    SyncedCron.start()

  if Meteor.isClient
    Router.go('timers.index')
