Caminio.SessionsSignupRoute = Ember.Route.extend
  model: ->
    Ember.Object.create
      email: null
      organization: null
      termsAccepted: false
      password: null