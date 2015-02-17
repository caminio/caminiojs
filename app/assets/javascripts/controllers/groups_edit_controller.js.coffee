Caminio.GroupsEditController = Ember.ObjectController.extend
  needs: ['application']
  group: null

  notyMessages: true

  actions:

    delete: (group)->
      group = group || @get('group')
      bootbox.confirm Em.I18n.t('group.really_delete', name: group.get('name')), (result)=>
        return unless result
        group
          .destroyRecord()
          .then =>
            noty 
              type: 'success'
              text: Em.I18n.t('group.deleted', name: group.get('name'))
            @transitionToRoute 'groups.index'
          .catch Caminio.NotyUnknownError

    save: (callback, scope)->
      @get('content')
        .save()
        .then ->
          if callback
            return callback.call(scope)
          noty
            type: 'success'
            text: Em.I18n.t('settings_saved')
        .catch Caminio.NotyUnknownError

