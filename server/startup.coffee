Meteor.startup ->
  Timer.find().forEach (t) ->
    SyncedCron.add
      name: t.name
      schedule: (parser) -> parser.text(t.schedule)
      job: ->
        LightModel.changeAll(t.data)
  SyncedCron.start()

ServiceConfiguration.configurations.remove
  service: 'github'

ServiceConfiguration.configurations.insert
  service: 'github'
  clientId: '519ce228c99d0b6c2389'
  loginStyle: 'popup'
  secret: '4630ebde7c03d4474a4159d09ff2c7782f0b8d9c'

Accounts.validateNewUser (user) ->
  user.services.github.username == 'stephanvane'
