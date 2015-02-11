Caminio.UsersNewRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'backLink', 'users.index'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'account.manage'

  model: ->
    org = @controllerFor('application').get('currentOrganization')
    @store.createRecord('user', { organization: org, locale: Em.I18n.locale })

