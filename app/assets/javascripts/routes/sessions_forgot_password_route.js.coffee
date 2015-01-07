Caminio.SessionsForgotPasswordRoute = Ember.Route.extend
  model: ->
    Ember.Object.create
      email: null
