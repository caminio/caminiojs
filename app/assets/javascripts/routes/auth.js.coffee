App.AuthRoute = Ember.Route.extend
  beforeModel: ->
    return if @.isAuthenticated()
    route = @
    @.authenticate()
      .then (api_key)->
        if( !api_key )
          route.transitionTo('sessions.new')
      .catch ()->
        route.transitionTo('sessions.new')

  isAuthenticated: ->
    @.store.getById('api_key', Ember.$.cookie 'caminio-session')

  authenticate: ->
    api_key = Ember.$.cookie 'caminio-session'
    unless Ember.$.cookie 'caminio-session'
      return this.transitionTo('sessions.new')
    controller = @.controllerFor('sessions')
    controller.store
      .find('api_key', api_key)
      .then (api_key)->
        console.log "here with api key "
        console.log api_key.get('user')
        controller.set 'currentUser', api_key.get('user')
        App.setAuthenticationBearer( api_key )

