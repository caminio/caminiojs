App.Router.map ->
  @resource 'dashboard.index', path: '/'
  @resource 'sessions', ->
    @route 'new'
    @route 'forgot_password'

