Router.configure
  layoutTemplate: 'layout'

Router.route('/', ->
  @render('lightsIndex')
)

Router.route('/timers', name: 'timers.index')
# Router.route('/timers', ->
#   @render('timersIndex')
# )
