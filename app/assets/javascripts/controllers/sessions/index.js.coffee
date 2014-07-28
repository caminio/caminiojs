App.SessionsController = Ember.Controller.extend
  login: null
  password: null

  reset: ->
    @setProperties
      login: ''
      password: ''
      errorMessage: ''

  actions:
    login: ->
      data = @getProperties 'login', 'password'
      controller = @
      Ember.$.post '/caminio/sessions', data
        .then (response)->
          Ember.$.cookie 'caminio-session', response.api_key.access_token
          App.setAuthenticationBearer( response.api_key.access_token )
          controller.set 'currentUser', controller.store.find('user',
            response.api_key.user_id)
          controller.transitionToRoute('dashboard.index')
        .fail (error)->
          if error.status == 401
            controller.set 'errorMessage', Em.I18n.t('invalid_username_or_password')

    # logout: ->
    #   controller = @
    #   Ember.$.ajax url: "/caminio/sessions/#{@get('currentApiKey.id')}",
    #     type: 'delete'
    #     .then (response)->
    #       Ember.$.removeCookie 'caminio-session'
    #       Ember.$.ajaxSetup
    #         headers:
    #           'Authorization': 'Bearer none'
    #       controller.set 'currentApiKey', null
    #       controller.set 'currentUser', null
    #
