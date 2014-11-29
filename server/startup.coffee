Meteor.startup ->
  Timer.find().forEach (t) ->
    SyncedCron.add
      name: t.name
      schedule: (parser) -> parser.text(t.schedule)
      job: ->
        LightModel.changeAll(t.data)
  SyncedCron.start()
