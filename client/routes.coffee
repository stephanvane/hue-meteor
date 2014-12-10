Router.configure
  layoutTemplate: 'layout'

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
Router.route('/timers', name: 'timers.index')
Router.route('/timers/:_id/edit', name: 'timers.edit', data: ->
  Timer.findOne(_id: @params._id)
)
# Router.route('/timers', ->
#   @render('timersIndex')
# )
