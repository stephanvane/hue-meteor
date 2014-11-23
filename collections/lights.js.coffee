URL = 'http://192.168.192.12/api/stephanvane/'

DEFAULT = 
  bri: 254
  hue: 14922
  sat: 144
  on: true

# Model
class @LightModel
  constructor: ({@id, @name}) ->

  change: (data, callback) ->
    Log.info("Changing light #{@id} to #{JSON.stringify(data)}")
    HTTP.put(
      "#{URL}lights/#{@id}/state"
      data: data
      (error, result) ->
        Log.error("Can't change light: #{error.stack}") if error
        callback() if callback
    )

  restore: ->
    @change(DEFAULT)

  blink: ->
    HTTP.get(
      "#{URL}lights/#{@id}"
      (_, result) =>
        currentState = JSON.parse(result.content).state

        @change(hue: 0, bri: 255, sat: 255, =>
          Meteor.setTimeout(
            => @change(currentState)
            1000
          )
        )
    )

  @changeAll: (data) ->
    Log.info("Changing all lights to #{JSON.stringify(data)}")
    HTTP.put(
      "#{URL}groups/0/action"
      data: data
      (error, result) ->
        Log.error("Can't change light: #{error.stack}") if error
    )

  @restore: ->
    @changeAll(DEFAULT)

# Collection
@Light = new Meteor.Collection 'lights',
  transform: (doc) ->
    new LightModel(doc)
