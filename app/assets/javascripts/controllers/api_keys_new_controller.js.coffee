Caminio.ApiKeysNewController = Ember.ObjectController.extend

  needs: ['application']
  
  actions:

    save: (callback, scope)->
      if typeof(callback) == 'function'
        return callback.call(scope)
      if Em.isEmpty @get('content.name')
        noty
          text: Em.I18n.t 'api_key.errors.name_required'
          type: 'error'
        return
      @get('content')
        .save()
        .then =>
          noty
            type: 'success'
            text: Em.I18n.t('saved', name: @get('content.name'))
          @transitionToRoute 'api_keys.index'
