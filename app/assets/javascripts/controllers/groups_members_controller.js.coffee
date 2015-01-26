Caminio.GroupsMembersController = Ember.ObjectController.extend
  needs: ['application']

  actions:

    removeUser: (user)->
      Ember.$.ajax
        url: "#{Caminio.get('apiHost')}/groups/#{@get('content.id')}/remove_member/#{user.get('id')}"
        type: 'post'
      .then (group)=>
          Em.$.noty.closeAll()
          noty( type: 'success', text: Em.I18n.t('group.member_removed', name: @get('content.name'), email: user.get('email')) )
          @store.find('group', id: group.group.id, time: new Date())
          @transitionToRoute 'groups.members', @get('content')



