# For more information see: http://emberjs.com/guides/routing/

Caminio.Router.map ->
  @route 'index', path: '/'
  @resource 'sessions', ->
    @route 'login'
    @route 'logout'
    @route 'forgot_password'
    @route 'signup'
    @route 'enter_confirmation_key'
