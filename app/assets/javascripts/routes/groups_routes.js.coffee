#
# INDEX
#
Caminio.GroupsIndexRoute = Caminio.AuthenticatedRoute.extend
  requireAdmin: true

  model: ->
    @store.find('group', clearCache: new Date())

  actions:

    editGroup: (group)->
      @transitionTo 'groups.edit', group.id

#
# NEW
#
Caminio.GroupsNewRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,

  setupController: (controller,model)->
    @_super controller, model
    org = @controllerFor('application').get('currentOrganization')
    controller.set 'group',
      @store.createRecord('group', organization: org)

  renderTemplate: (controller)->
    indexController = @controllerFor 'groups_index'
    indexController.set 'content', controller.get 'content'
    @render 'groups.index',
      controller: indexController
    @render 'groups.new',
      outlet: 'modal'

  willTransition: (transition)->
    if @get('controller.group.isNew')
      @get('controller.group').destroyRecord()
    true


#
# EDIT
#
Caminio.GroupsEditRoute = Caminio.GroupsIndexRoute.extend

  model: (params)->
    @store
      .find 'group', params.id
      .then (group)=>
        @controllerFor('groups_edit').set 'group', group
    @_super()

  renderTemplate: (controller)->
    indexController = @controllerFor 'groups_index'
    indexController.set 'content', controller.get 'content'
    @render 'groups.index',
      controller: indexController
    @render 'groups.edit',
      outlet: 'modal'


#
# MEMBERS
#
Caminio.GroupsMembersRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,

  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'backLink', 'groups.index'
    @controllerFor('application').set 'newBtnLink', 'users.new'
    @controllerFor('application').set 'newBtnLinkHint', 'account.create_account'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'groups.manage'

  model: (params)->
    @store.find('group',params.id)

#
# ADD MEMBER
#
Caminio.GroupsAddMemberRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,

  setupController: (controller,model)->
    @_super controller, model
    @controllerFor('application').set 'backLink', 'groups.index'
    @controllerFor('application').set 'newBtnLink', 'groups.new'
    @controllerFor('application').set 'newBtnLinkHint', 'group.create_new'
    @controllerFor('application').set 'routeTitle', Em.I18n.t 'groups.manage'

  model: (params)->
    @store.find('group',params.id)


