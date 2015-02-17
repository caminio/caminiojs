Caminio.GroupsNewController = Ember.ObjectController.extend
  needs: ['application']
  group: null

  actions:
    save: ->
      @get('group')
        .save()
        .then =>
          Em.$.noty.closeAll()
          noty( type: 'success', text: Em.I18n.t('saved', name: @get('group.name')) )
          @transitionToRoute 'groups.index'

