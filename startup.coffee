Meteor.startup ->
  urls = [
    'http://77.248.22.140:9999/api/stephanvane/'
    'http://192.168.192.12/api/stephanvane/'
  ]

  _.each urls, (url) ->
    HTTP.get url, (e, res) ->
      if !e?
        if Meteor.isClient
          Session.set('url', url)
        else
          Meteor.settings.url = url
