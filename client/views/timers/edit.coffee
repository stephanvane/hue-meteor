Template.timersEdit.created = ->
  @nextRun = new ReactiveVar('a')
  @nextRun.set('a')

Template.timersEdit.helpers
  getNext: ->
    debugger
    Template.instance().nextRun.get()

Template.timersEdit.events
  'keyup input[name=schedule]': (e) ->
    later.date.localTime()
    s = later.parse.text(e.target.value)
    if s.error == -1
      next = moment(later.schedule(s).next()).format('MMM Do, HH:mm')
      # Session.set('nextRun', next)
      Template.instance().nextRun.set(next)
    else
      Template.instance().nextRun.set("error(#{s.error})")
      # Session.set('nextRun', "error(#{s.error})")
