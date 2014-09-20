App.ApplicationRoute = Ember.Route.extend

  beforeModel: ->
    return unless @get('auth')
    return if @.isAuthenticated()
    route = @
    @.authenticate()
      .then (user)->
        if !user
          return route.transitionTo('sessions.new')
        if App.get('currentOu.app_plans.length') < 1
          return route.transitionTo('accounts.plans')
        # if route.get('lazyLoadUrl')
        #   Em.$.getScript(route.get('lazyLoadUrl'))
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
        console.log api_key._data.user_id
        api_key.get('user').then (user)->
          controller.store.find('app_plan', user_id: user.id)
            .then ->
              App.setAuthenticationBearer( api_key.get('access_token'), user )
              user

  actions:

    openModal: (modalName, controller)->
      if controller
        return @.render modalName, into: 'application', outlet: 'modal', controller: controller
      @.render modalName, into: 'application', outlet: 'modal'

    closeModal: ->
      @.disconnectOutlet outlet: 'modal', parentView: 'application'
