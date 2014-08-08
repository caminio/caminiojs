App.ApplicationController = Ember.Controller.extend
  needs: ['sessions']
  apps: []

  currentUser: (->
    @get 'controllers.sessions.currentUser'
  ).property('controllers.sessions.currentUser')

  isAuthenticated: (->
    return false if @.store.all('api_key').get('length') < 1
    @.store.getById('api_key', Ember.$.cookie 'caminio-session')
  ).property('controllers.sessions.currentUser'),

  init: ->
    @._super()
    sessionsController = @.get('controllers.sessions')
    controller = @
    return unless sessionsController.get('currentUser')
    @.get('controllers.sessions.currentUser')
      .then (currentUser)->
        controller.store.find('app_plan', user_id: currentUser.id)
          .then ->
            controller.set('appsModels',controller.store.all('app_model'))
            controller.get('appsModels').forEach (appModel)->
              unless Em.isEmpty(appModel.get('add_js'))
                Em.$.getScript("/assets/#{appModel.get('add_js')}")

