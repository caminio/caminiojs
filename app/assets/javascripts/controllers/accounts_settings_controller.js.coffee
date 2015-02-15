Caminio.AccountsSettingsController = Ember.ObjectController.extend
  needs: ['application']
  
  users: Em.A()
  groups: Em.A()
  organizations: Em.A()

  otherOrganizationsAmount: (->
    @organizations.rejectBy('id', @get('controllers.application.currentOrganization.id')).length
  ).property 'organizations.@each'

  # usersProgressStyle: (->
  #   quota = @get('controllers.application.currentOrganization.user_quota')
  #   currentlyUsed = @get('users.length')
  #   "width: #{currentlyUsed / (quota / 100)}%"
  # ).property 'users.@each'

  onlineUsersNum: (->
    @get('users')
      .filter (user)->
        user.get('last_request_at') > moment().subtract(10,'m').toDate()
      .length
  ).property 'users.@each'

  largestGroup: (->
    g = null
    @get('groups').forEach (group)->
      return g = group unless g
      g = group if group.get('users.length') > g.get('users.length')
    g
  ).property 'groups.@each'

  showOrgItems: false
  loadingUsers: false
  loadingGroups: false

  actions:

    toggleOrgItems: ->
      @toggleProperty 'showOrgItems'
      return

    goTo: (route)->
      @transitionToRoute route

    switchOrganization: (org)->
      @get('controllers.application').set 'currentOrganization', org
      Ember.$.cookie('organization_id', org.id)
      Ember.$.ajaxSetup
        headers: { 'Organization_id': org.id }
      @set 'loadingUsers', true
      @set 'loadingGroups', true
      @store.find('user', { clearCache: new Date() })
        .then (users)=>
          @set 'users', users
          @set 'loadingUsers', false
          @store.find('group', { clearCache: new Date() })
          .then (groups)=>
            @set 'groups', groups
            @set 'loadingGroups', false
            @set 'showOrgItems', false

Caminio.OrganizationItemController = Ember.ObjectController.extend

  isCurrentOrganization: (->
    @get('content.id') == @get('parentController.controllers.application.currentOrganization.id')
  ).property 'parentController.controllers.application.currentOrganization'