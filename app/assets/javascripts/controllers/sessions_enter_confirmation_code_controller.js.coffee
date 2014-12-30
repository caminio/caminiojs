Caminio.SessionsEnterConfirmationCodeController = Ember.ObjectController.extend Caminio.Validations,

  validate:
    code:
      required:
        message: Em.I18n.t('errors.code_required')

  actions:

    checkCode: ->
      return unless @isValid()
      Ember.$.post("#{Caminio.get('apiHost')}/users/check_code", @getProperties('code'))
        .then (res)=>
          @transitionToRoute 'dashboard'
        .fail (err)=>
          json = err.responseJSON
          if( err.status == 409 )
            @set 'valid', false
            if( json.error == 'InvalidCode' )
              @set 'message', Em.I18n.t('errors.invalid_code')
              @set 'errors.code', true
            else
              @set 'message', Em.I18n.t('errors.unknown')

