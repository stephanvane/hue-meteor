Meteor.subscribe('lights')

Template.header.helpers
  lights: ->
    Light.find()

Template.header.rendered = ->
  menu = $('#navigation-menu')
  menuToggle = $('#js-mobile-menu')
  signUp = $('.sign-up')

  $(menuToggle).on 'click', (e) ->
    e.preventDefault()
    menu.slideToggle ->
      if menu.is(':hidden')
        menu.removeAttr('style')
