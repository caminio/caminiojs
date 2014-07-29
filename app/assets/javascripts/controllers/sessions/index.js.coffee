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
          controller.authenticate(response.api_key)
        .fail (error)->
          if error.status == 401
            controller.set 'errorMessage', Em.I18n.t('invalid_username_or_password')

  authenticate: (api_key)->
    Ember.$.cookie 'caminio-session', api_key.access_token
    App.setAuthenticationBearer( api_key.access_token )
    @.store.find('organizational_unit')
    @.set 'currentUser', @.store.find('user',
      api_key.user_id)
    @.transitionToRoute('dashboard.index')
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
