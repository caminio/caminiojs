App.SessionsResetPasswordRoute = Ember.Route.extend
  beforeModel: (options)->
    @set('user_id', options.queryParams.id)
    @set('confirmation_key',options.queryParams.confirmation_key)
  setupController: (controller,model)->
    controller.set('user_id',@get('user_id'))
    controller.set('confirmation_key',@get('confirmation_key'))
