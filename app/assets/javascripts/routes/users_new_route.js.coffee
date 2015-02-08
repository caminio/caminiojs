Caminio.UsersNewRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  model: ->
    org = @controllerFor('application').get('currentOrganization')
    @store.createRecord('user', { organization: org, locale: Em.I18n.locale })
