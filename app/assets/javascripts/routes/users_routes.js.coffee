# coffeelint: disable=max_line_length

#
# INDEX
#
Caminio.UsersIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true
  
  model: ->
    @store
      .find('user', clearCache: new Date())

  actions:

    editUser: (user)->
      @transitionTo 'users.edit', user.id
    # editUser: (user)->
    #   editController = @controllerFor('users_edit')
    #   editController.set('content', user)
    #   @render 'users.edit',
    #     into: 'application'
    #     outlet: 'modal'
    #     controller: editController

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
Caminio.UsersEditRoute = Caminio.UsersIndexRoute.extend

  model: (params)->
    @store
      .find 'user', params.id
      .then (user)=>
        @controllerFor('users_edit').set 'user', user
    @_super()

  renderTemplate: (controller)->
    indexController = @controllerFor 'users_index'
    indexController.set 'content', controller.get 'content'
    @render 'users.index',
      controller: indexController
    @render 'users.edit',
      outlet: 'modal'
