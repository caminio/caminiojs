App.AuthRoute = App.ApplicationRoute.extend
  beforeModel: ->
    return if @.isAuthenticated()
    route = @
    @.authenticate()
      .then (user)->
        if !user
          route.transitionTo('sessions.new')
        if user.get('current_organizational_unit.app_plans.length') < 1
          route.transitionTo('accounts.plans')
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
        api_key.get('user').then (user)->
          App.setAuthenticationBearer( api_key.get('access_token'), user )
          user

