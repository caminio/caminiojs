Caminio.GroupsEditController = Ember.ObjectController.extend Caminio.Validations,
  needs: ['application']

  notyMessages: true

  actions:

    deleteGroup: (group)->
      group = group || @get('content')
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

