App.SessionsLogoutRoute = Ember.Route.extend

  setupController: (controller)->
    Ember.$.ajax url: "/caminio/sessions", type: 'delete'
    .done (response)->
      Ember.$.removeCookie 'caminio-session'
      controller.get('controllers.sessions').set('currentUser',null)
      controller.store.unloadAll('api_key')
      controller.transitionToRoute('sessions.new')
