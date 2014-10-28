App.SessionsLogoutRoute = Ember.Route.extend

  setupController: (controller)->
    Ember.$.ajax url: "/caminio/auth", type: 'delete'
    .done (response)->
      Ember.$.removeCookie 'caminio-session'
      location.href = '/caminio/'
