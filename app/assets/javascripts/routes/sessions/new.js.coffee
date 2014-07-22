App.SessionsNewRoute = Ember.Route.extend

  isAuthenticated: ->
    @.store.find('api_key', Ember.$.cookie 'caminio-session')

  beforeModel: ->
    route = @
    @.isAuthenticated()
      .then ->
        console.log "here check if log in #"
        route.transitionTo "dashboard.index"
      .catch ->
        console.log "not authenticated"

  setupController: (controller, model)->
    controller.reset()
