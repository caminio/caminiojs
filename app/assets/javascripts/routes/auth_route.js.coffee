App.AuthRoute = App.ApplicationRoute.extend
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
      Ember.$.removeCookie 'caminio-session'
      return this.transitionTo('sessions.new')
    controller = @.controllerFor('sessions')
    controller.store
      .find('api_key', api_key)
      .then (api_key)->
        App.setAuthenticationBearer( api_key.get('access_token') )
        controller.set 'currentUser', api_key.get('user')

