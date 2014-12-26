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

Template.header.events
  'click .login': (e) ->
    # Meteor.loginWithGithub(
    #   requestPermissions: ['user:email', 'user', 'user:follow','public_repo', 'repo', 'repo_deployment', 'repo:status', 'delete_repo', 'notifications', 'gist', 'read:repo_hook', 'write:repo_hook', 'admin:repo_hook', 'admin:org_hook', 'read:org', 'write:org', 'admin:org', 'read:public_key', 'write:public_key', 'admin:public_key']
    #   (e) ->
    #     console.log(e)
    # )
    Meteor.loginWithFacebook()

  'click .logout': (e) ->
    Meteor.logout()
