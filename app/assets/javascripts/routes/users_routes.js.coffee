# coffeelint: disable=max_line_length

#
# INDEX
#
Caminio.UsersIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true
  
  model: ->
    @store
      .find('user', clearCache: new Date())

#
# NEW
#
Caminio.UsersNewRoute = Caminio.UsersIndexRoute.extend

  setupController: (controller,model)->
    @_super controller, model
    org = @controllerFor('application').get('currentOrganization')
    controller.set 'user',
      @store.createRecord('user',
        organization: org,
        locale: Em.I18n.locale)

  renderTemplate: (controller)->
    console.log arguments
    indexController = @controllerFor 'users_index'
    indexController.set 'content', controller.get 'content'
    @render 'users.index',
      controller: indexController
    @render 'users.new',
      outlet: 'modal'

  willTransition: (transition)->
    if @get('controller.user.isNew')
      @get('controller.user').destroyRecord()
    true



#
# EDIT
#
Caminio.UsersEditRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  requireAdmin: true
  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'backLink', 'users.index'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'account.manage'
    
  model: (params)->
    @store.find 'user', params.id