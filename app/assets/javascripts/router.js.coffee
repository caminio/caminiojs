App.Router.map ->
  @resource 'dashboard.index', path: '/'
  @resource 'sessions', ->
    @route 'new'
    @route 'logout'
    @route 'forgot_password'
    @route 'reset_password'
    @route 'signup'
  @resource 'accounts', ->
    @route 'index'
    @route 'plans'
    @route 'organizations'
    @route 'invoices'
    @route 'users'
    @route 'users.new', path: '/users/new'
    @route 'users.edit', path: '/users/edit/:id'
    @route 'users.change_password', path: '/users/change_password/:id'

  @resource 'crm.index', path: '/crm'

