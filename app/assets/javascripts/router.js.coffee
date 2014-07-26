App.Router.map ->
  @resource 'dashboard.index', path: '/'
  @resource 'sessions', ->
    @route 'new'
    @route 'logout'
    @route 'forgot_password'
  @resource 'accounts', ->
    @route 'show', path: '/accounts/:id/show'

