Caminio.SessionsResetPasswordRoute = Ember.Route.extend
  model: (params)->
    Ember.Object.create
      id: params.id
      confirmation_key: params.confirmation_key
      password: null
