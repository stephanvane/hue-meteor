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
ServiceConfiguration.configurations.remove
  service: 'facebook'

ServiceConfiguration.configurations.insert
  service: 'github'
  clientId: '519ce228c99d0b6c2389'
  loginStyle: 'popup'
  secret: '4630ebde7c03d4474a4159d09ff2c7782f0b8d9c'

ServiceConfiguration.configurations.insert
  service: 'facebook'
  appId: '1539044769668616'
  secret: '0c980057f801a66f03141e80053284e6'

Accounts.validateNewUser (user) ->
  return user.profile.email == 'stephanvane@gmail.com'

Accounts.onCreateUser (options, user) ->
  if (options.profile)
    user.profile = options.profile;
    user.profile.email=user.services.facebook.email

  return user
