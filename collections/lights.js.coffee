URL = 'http://ewe192.168.192.12/api/stephanvane/'

# Model
class Light
  constructor: ({@id, @name}) ->

  change: (data) ->
    Log.info("Changing light #{@id} to #{JSON.stringify(data)}")
    HTTP.put(
      "#{URL}lights/#{@id}/state"
      data: data
      (error, result) ->
        Log.error("Can't change light: #{error.stack}") if error
    )

# Collection
@Light = new Meteor.Collection 'lights',
  transform: (doc) ->
    new Light(doc)
