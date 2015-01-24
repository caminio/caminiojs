Caminio.GroupsEditController = Ember.ObjectController.extend Caminio.Validations,
  needs: ['application']

  requireAdmin: true
  notyMessages: true

  actions:
    save: (callback, scope)->
      @get('content')
        .save()
        .then ->
          callback.call(scope)

    delete: ->

      if @get('content.id') == @get('controllers.application.currentUser.id')
        return noty({ type: 'error', text: Em.I18n.t('errors.please_remove_yourself_in_your_account_settings') })

      bootbox.prompt Em.I18n.t('user.really_delete', email: @get('content.email')), (result)=>
        if result != @get('content.email')
          return noty({ type: 'warning', text: Em.I18n.t('aborted')})
        @get('content')
          .destroyRecord()
          .then =>
            noty
              type: 'success'
              text: Em.I18n.t('user.has_been_deleted', name: @get('content.name'))
            @transitionToRoute 'users.index'
          .catch (err)->
            console.log 'error', err
            noty
              type: 'error'
              timeout: false
              text: Em.I18n.t('errors.unknown')