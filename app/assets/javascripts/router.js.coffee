# For more information see: http://emberjs.com/guides/routing/

Caminio.Router.map ->
  @route 'index', path: '/'
  @resource 'subscriptions', ->
    @route 'manage'
    @route 'confirm_change', path: 'confirm_change/:plan_name'
  @resource 'sessions', ->
    @route 'login'
    @route 'logout'
    @route 'forgot_password'
    @route 'reset_password', path: 'reset_password/:id/:confirmation_key'
    @route 'signup'
    @route 'confirm', path: 'confirm/:id/:confirmation_key'
  @resource 'accounts', ->
    @route 'mine'
    @route 'admin'
  @resource 'users', ->
    @route 'index'
    @route 'new'
    @route 'edit', path: ':id'
  @resource 'groups', ->
    @route 'new'
    @route 'index'
    @route 'edit', path: ':id'
    @route 'members', path: 'members/:id'
    @route 'add_member', path: 'add_member/:id'
  @resource 'organizations', ->
    @route 'new'
    @route 'edit', path: ':id'
