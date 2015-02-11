Caminio.OrganizationsEditRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,

  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'backLink', 'accounts.admin'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'account.manage'

  model: (params)->
    @store.find('organization',params.id)

