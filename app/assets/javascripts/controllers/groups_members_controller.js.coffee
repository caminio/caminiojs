Caminio.GroupsMembersController = Ember.ObjectController.extend Caminio.Validations,
  needs: ['application']

  actions:
    save: (callback, scope)->
      @get('content')
        .save()
        .then ->
          if callback
            return callback.call(scope)
          noty
            type: 'success'
            text: Em.I18n.t('settings_saved')

