App.ApplicationController = Ember.Controller.extend
  needs: ['sessions']
  apps: []

  currentUser: (->
    @get 'controllers.sessions.currentUser'
  ).property('controllers.sessions.currentUser')

  isAuthenticated: (->
    @.store.getById('api_key', Ember.$.cookie 'caminio-session')
  ).property('controllers.sessions.currentUser'),

  init: ->
    @._super()
    @.loadApps()

  appsObserver: (->
    @.loadApps()
  ).observes('controllers.sessions.currentUser')

  loadApps: ->
    console.log "current user #{@.get('controllers.sessions.currentUser')}"
    return unless @.get('controllers.sessions.currentUser')
    Ember.$.getJSON "/users/#{@.get('controllers.sessions.currentUser.id')}/apps"
      .then (response)->
        @.set('apps',response)
