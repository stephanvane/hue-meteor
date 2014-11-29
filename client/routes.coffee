Router.configure
  layoutTemplate: 'layout'

Router.route('/', ->
  @render('lightsIndex')
)

Router.route('/timers', name: 'timers.index')
Router.route('/timers/:_id/edit', name: 'timers.edit', data: ->
  Timer.findOne(_id: @params._id)
)
# Router.route('/timers', ->
#   @render('timersIndex')
# )
