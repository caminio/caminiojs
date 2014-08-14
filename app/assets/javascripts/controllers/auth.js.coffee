App.AuthController = Ember.Controller.extend

  needs: ['sessions']

  currentUser: (->
    @get 'controllers.sessions.currentUser'
  ).property('controllers.sessions.currentUser')

  currentOu: (->
    @get 'controllers.sessions.currentOU' || @get 'controllers.sessions.currentUser.organizational_units.firstObject' 
  ).property('controllers.sessions.currentUser.organizational_unit')

  isAuthenticated: (->
    Ember.isEmpty @get('controllers.sessions.currentUser')
  ).property('controllers.sessions.currentUser')
