Caminio.GroupsAddMemberController = Ember.ObjectController.extend
  needs: ['application']

  email: null

  actions:
    add: ->
      Ember.$.ajax
        url: "#{Caminio.get('apiHost')}/groups/#{@get('content.id')}/add_member"
        data:
          email: @get 'email'
        type: 'post'
      .then (group)=>
          Em.$.noty.closeAll()
          @store.find('group', id: group.group.id, time: new Date())
          noty( type: 'success', text: Em.I18n.t('group.member_added', name: @get('content.name'), email: @get('email')) )
          @transitionToRoute 'groups.members', @get('content')