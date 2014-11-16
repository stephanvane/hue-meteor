URL = 'http://192.168.192.12/api/stephanvane/'

# Model
class Light
  constructor: (doc) ->
    @id = doc.id
    @name = doc.name

  change: (data) ->
    HTTP.put("#{URL}lights/#{@id}/state", {
      data: data
    }, (_, result) ->
    )

# Collection
@Light = new Meteor.Collection 'lights',
  transform: (doc) ->
    new Light(doc)
