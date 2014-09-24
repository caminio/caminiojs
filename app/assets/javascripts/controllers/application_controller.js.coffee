App.ApplicationController = Ember.Controller.extend
  needs: ['sessions']
  apps: []

  currentUser: (->
    @get 'controllers.sessions.currentUser'
  ).property 'controllers.sessions.currentUser'

  currentOu: (->
    App.get 'currentOu'
  ).property 'App.currentOu'

  isAuthenticated: (->
    return false if @.store.all('api_key').get('length') < 1
    @store.getById('api_key', Ember.$.cookie 'caminio-session')
  ).property('controllers.sessions.currentUser')

  availableApps: (->
    return [] unless App.get('currentOu')
    App.get('currentOu.app_plans').map (app_plan)->
      app = app_plan.get('app')
      app.set('current_plan', app_plan)
  ).property 'App.currentUser.app_plans.@each', 'App.currentOu.app_plans.@each'

#  init: ->
#    @_super()
#    sessionsController = @get('controllers.sessions')
#    controller = @
#    return unless sessionsController.get('currentUser')
#    @get('controllers.sessions.currentUser')
#      .then (currentUser)->
#        controller.store.find('app_plan', user_id: currentUser.id)
#          .then ->
#            controller.set('availableApps',controller.store.all('app'))

