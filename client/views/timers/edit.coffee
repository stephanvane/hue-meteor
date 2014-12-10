Template.timersEdit.rendered = ->
  Session.set('nextRun', parseSchedule(this.data.schedule))

Template.timersEdit.helpers
  getNext: ->
    Session.get('nextRun')

Template.timersEdit.events
  'keyup input[name=schedule]': (e) ->
    Session.set('nextRun', parseSchedule(e.target.value))

# private
parseSchedule = (text) ->
  later.date.localTime()
  s = later.parse.text(text)
  if s.error == -1
    moment(later.schedule(s).next()).format('MMM Do, HH:mm')
  else
    "error(#{s.error})"
