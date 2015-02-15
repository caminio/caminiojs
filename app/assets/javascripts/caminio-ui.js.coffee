# common settings

# language
window.LANG = $('html').attr('lang')

Ember.I18n.locale = (Ember.$.cookie('locale') || LANG).replace(/\"/g,'')
Ember.I18n.translations = Ember.I18n.availableTranslations[Ember.I18n.locale]
# inject <attr>Translation into {{input }} helper
Ember.TextField.reopen(Ember.I18n.TranslateableAttributes)

accounting.settings =
  currency:
    symbol : "€ "
    format: "%s%v"
    decimal : ","
    thousand: " "
    precision : 2
  number:
    precision : 0
    thousand: ","
    decimal : "."

moment.locale(LANG)

DS.ObjectTransform = DS.Transform.extend
  deserialize: (serialized)->
    return {} if Em.isNone(serialized)
    serialized
  serialize: (deserialized)->
    return {} if Em.isNone(deserialized)
    deserialized

Caminio.register("transform:object", DS.ObjectTransform)

DS.ArrayTransform = DS.Transform.extend
  deserialize: (serialized)->
    return [] if Em.isNone(serialized)
    serialized
  serialize: (deserialized)->
    return [] if Em.isNone(deserialized)
    deserialized

Caminio.register("transform:array", DS.ArrayTransform)


$.cookie.json = true

Caminio.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'api/v1'
  pathForType: (type)->
    decamelized = Ember.String.decamelize(type)
    Ember.String.pluralize(decamelized)

Caminio.ApplicationStore = DS.Store.extend()

#
# AuthenticatedRoute
#
Caminio.AuthenticatedRoute = Ember.Route.extend
  init: ->
    @_super()
    if Ember.$.cookie('access_token') #&& Ember.$.cookie('organization_id')
      Ember.$.ajaxSetup
        headers: { 'Authorization': 'Bearer ' + Ember.$.cookie('access_token') } #, 'Organization_id': Ember.$.cookie('organization_id') }

  beforeModel: (transition)->
    userId = Ember.$.cookie('user_id')
    # orgId = Ember.$.cookie('organization_id')
    unless userId
      @controllerFor('sessions').setProperties( token: null, userId: null, organizationId: null )
      return @redirectToLogin(transition)
    @store.find 'user', userId
      .then (user)=>
        @redirectToLogin(transition) unless user
        @checkAdmin(user) if @get('requireAdmin')
        # @store.find 'organization', orgId
        $('body').removeClass('authorization-required')
      .catch (error)=>
        console.log 'error caught', error
        @controllerFor('sessions').reset()
        @transitionTo 'sessions'

  checkAdmin: (user)->
    return if user.get('admin')
    @transitionTo 'index'

  redirectToLogin: (transition)->
    @controllerFor('sessions').set('attemptedTransition', transition)
    @transitionTo 'sessions'

  # actions:
  #   # recover from any error that may happen during the transition to this route
  #   error: (reason, transition)->
  #     if (reason.status is 401)
  #       return @redirectToLogin(transition)
  #     console.log('unknown problem', transition, reason)

#
# SessionsRoute
#
Caminio.SessionsRoute = Ember.Route.extend
  setupController: (controller, context)->
    controller.reset()

  beforeModel: (transition)->
    return if Ember.isEmpty(@controllerFor('sessions').get('token'))
    @transitionTo 'index'

#
# SessionsController
#
Caminio.SessionsController = Ember.Controller.extend

  login: ''
  password: ''

  openRegistration: (if typeof(CAMINIO_SHOW_OPEN_REG_LINK) == 'boolean' then CAMINIO_SHOW_OPEN_REG_LINK else true)

  availableLocales: [{ label: 'Deutsch', value: 'de'}, { label: 'English', value: 'en' }]
  availableRoles: [
    { label: Em.I18n.t('roles.user'), value: 'user' }
    { label: Em.I18n.t('roles.editor'), value: 'editor' }
    { label: Em.I18n.t('roles.admin'), value: 'admin' }
  ]
  selectedLocale: Ember.I18n.locale
  observeSelectedLocale: (->
    return unless @get('selectedLocale')
    Ember.$.cookie 'locale', @get('selectedLocale')
    Em.I18n.locale = @get('selectedLocale')
    location.reload()
  ).observes 'selectedLocale'

  attemptedTransition: null

  token: Ember.$.cookie('access_token')

  userId: Ember.$.cookie('user_id')

  organizationId: Ember.$.cookie('organization_id')

  tokenChanged: (->
    if Ember.isEmpty(@get('token'))
      Ember.$.removeCookie('access_token')
      Ember.$.removeCookie('user_id')
      # Ember.$.removeCookie('organization_id')
    else
      Ember.$.cookie('access_token', @get('token'))
      Ember.$.cookie('user_id', @get('userId'))
      # Ember.$.cookie('organization_id', @get('organizationId'))
  ).observes 'token', 'userId'

  reset: ->
    @setProperties
      login: null
      password: null
      token: null
      userId: null
      organizationId: null
    
    Ember.$.ajaxSetup
      headers: { 'Authorization': 'Bearer none', 'Organization_id': undefined }

Caminio.SessionsIndexController = Caminio.SessionsController.extend

  needs: ['sessions']

  actions:
  
    loginUser: ->
      data = @getProperties('login', 'password')
      attemptedTrans = @get('attemptedTransition')

      @setProperties
        login: null
        password: null
        message: null

      Ember.$.post('/api/v1/auth', data)
        .then (response)=>
          Ember.$.ajaxSetup
            headers: { 'Authorization': 'Bearer ' + response.api_key.token }
          # @get('store').find('apiKey').forEach (apiKey)-> apiKey.destroyRecord()
          # key = @get('store').createRecord('apiKey', response.api_key )
          @get('controllers.sessions').set('token', response.api_key.token)
          @store.find('user', response.api_key.user_id)
            .then (user)=>
              console.log 'here', user.get('organizations.firstObject')
              @get('controllers.sessions').set('organizationId', user.get('organizations.firstObject.id'))
              console.log 'still here'
              @get('controllers.sessions').set('userId', user.get('id'))
              Ember.$.ajaxSetup
                headers: { 'Organization_id': @get('controllers.sessions.organizationId') }
              if attemptedTrans
                attemptedTrans.retry()
                @set('attemptedTransition', null)
              else
                @transitionToRoute 'index'
        .fail (error)=>
          if error.status is 401
            @set('message', Em.I18n.t('errors.login_failed'))
            $('input[type=text]:visible:first').focus()

#
# ApplicationView
#
Caminio.ApplicationView = Ember.View.extend

  checkSidePane: (e)->
    if ($(e.target).closest('.toggle-side-pane').length > 0 || $(e.target).hasClass('toggle-side-pane')) ||
        ($(e.target).closest('.side-pane').length > 0 && 
         !($(e.target).closest('.side-pane-link').length > 0 || $(e.target).hasClass('side-pane-link')))
      return
    if $('body > div > div').hasClass('side-pane-open')
      @get('controller').set 'sidePaneOpen', false

  checkAccountInfo: (e)->
    if $(e.target).closest('.top-pane').length < 1 && $('.top-pane').hasClass('account-info-open')
      @get('controller').set 'accountInfoOpen', false

  didInsertElement: ->
    @$(document)
      .on 'click', (e)=>
        @checkSidePane(e)
        @checkAccountInfo(e)

    @$('input#search-query')
      .on 'focus', (e)=>
        @get('controller').set 'sidePaneOpen', true 

#
# ApplicationController
#
Caminio.ApplicationController = Ember.Controller.extend
  needs:  ['sessions']

  appName: (window.APP_NAME || 'caminio')

  appLink: (window.APP_LINK || 'https://camin.io')

  sidePaneOpen: false
  accountInfoOpen: false

  currentUser: Em.computed ->
    @store.getById 'user', @get('controllers.sessions.userId')
  .property 'controllers.sessions.userId'

  currentOrganization: Em.computed ->
    console.log 'DEPRECATION WARNING: deprecated. user currentUser.get("organization")'
    @get('currentUser.organization')
  .property 'currentUser'

  isAuthenticated: Em.computed ->
    !!@get('currentUser')
  .property 'controllers.sessions.token', 'controllers.sessions.userId'

  actions:

    toggleAccountInfo: ->
      @toggleProperty 'accountInfoOpen'
      return

    toggleSidePane: ->
      return if $('input#search-query').is(':focus')
      @toggleProperty 'sidePaneOpen'
      if @get('sidePaneOpen')
        $('input#search-query').focus()
      return

    logout: ->
      console.log 'here logout'
      for cookie in $.cookie()
        $.removeCookie cookie
      $.ajax
        url: "#{Caminio.get('apiHost')}/auth"
        type: 'delete'
      .then =>
        @get('controllers.sessions').reset()
        @transitionToRoute 'sessions.index'

  availableColors: [
    '#f44336'
    '#e91e63'
    '#9c27b0'
    '#673ab7'
    '#3f51b5'
    '#2196f3'
    '#03a9f4'
    '#00bcd4'
    '#009688'
    '#4caf50'
    '#8bc34a'
    '#cddc39'
    '#ffeb3b'
    '#ffc107'
    '#ff9800'
    '#ff5722'
    '#795548'
    '#9e9e9e'
    '#607d8b'
  ]

Caminio.DestroyOnCancelMixin = Ember.Mixin.create

  actions:
    willTransition: (transition)->
      if @get('controller.content.isNew')
        @get('controller.content').destroyRecord()
      true

Caminio.NotyUnknownError = (err)->
  console.log 'error', err
  noty
    type: 'error'
    text: Em.I18n.t('errors.unknown')
    timeout: false

