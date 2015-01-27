Caminio.AccountsShowController = Ember.ObjectController.extend
  needs: ['application', 'sessions']

  actions:

    savePassword: (callback,scope)->
      bootbox.prompt 
        title: Em.I18n.t('account.enter_current_password')
        inputType: 'password'
        callback: (result)=>
          Ember.$.ajax
            type: 'post'
            data: 
              old: result
              new: @get('content.password')
            url: Caminio.get('apiHost')+'/users/change_password'
          .then =>
            callback.call(scope)
            @get('content').set('password','')
            @get('content').save()
          .fail (err)->
            if err.status == 403
              noty
                type: 'error'
                text: Em.I18n.t('account.wrong_password')
            else
              console.log 'error', err

    save: (callback, scope)->
      @get('content')
        .save()
        .then ->
          callback.call(scope)
        .catch Caminio.NotyUnknownError

Caminio.AccountsMineController = Caminio.AccountsShowController.extend()
