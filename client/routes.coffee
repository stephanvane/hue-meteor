Router.configure
  layoutTemplate: 'layout'

Router.onBeforeAction ->
  if (!Meteor.userId())
    @render('login')
  else
    @next()

Router.route('/', ->
  @render('lightsIndex')
  @render('lightsSubNav', to: 'subNav')
)

# Lights
Router.route('/lights/:_id/edit', name: 'lights.edit', data: ->
  Light.findOne(_id: @params._id)
)
Router.route('/lights/new', name: 'lights.new')

# Timers
Router.route(
  '/timers'
  ->
    @render('timersIndex')
    @render('timersSubNav', to: 'subNav')
  name: 'timers.index'
)
Router.route('/timers/new', name: 'timers.new')


Router.route('/timers/:_id/edit', name: 'timers.edit', data: ->
  Timer.findOne(_id: @params._id)
)

Router.route('/presets', name: 'presets.index')
# Router.route('/timers', ->
#   @render('timersIndex')
# )
