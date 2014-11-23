Meteor.startup ->
  Timer.find().forEach (t) ->
    SyncedCron.add
      name: t.name
      schedule: -> (t.schedule)
      job: ->
        LightModel.changeAll(hue: 0)
  SyncedCron.start()
