Caminio.SessionsConfirmController = Ember.ObjectController.extend Caminio.Validations,

  needs: ['sessions']

  validate:
    confirmation_code:
      required:
        message: Em.I18n.t('errors.code_required')

  actions:

    checkCode: ->
      return unless @isValid()
      Ember.$.post("#{Caminio.get('apiHost')}/users/#{@get('content.id')}/confirm", @getProperties('confirmation_code', 'confirmation_key'))
        .then (response)=>
          Ember.$.ajaxSetup
            headers: { 'Authorization': 'Bearer ' + response.api_key.token, 'Organization_id': response.api_key.organization_id }
          @store.find('user', @get('id'))
            .then (user)=>
              @get('controllers.sessions').setProperties
                token: response.api_key.token
                organizationId: response.api_key.organization_id
                userId: user.get('id')
              @transitionToRoute 'index'
        .fail (err)=>
          json = err.responseJSON
          if( err.status == 409 )
            @set 'valid', false
            if( json.error == 'InvalidCode' )
              @set 'message', Em.I18n.t('errors.invalid_code')
              @set 'errors.code', true
            if( json.error == 'InvalidKey' )
              @set 'message', Em.I18n.t('errors.key_invalid_or_expired')
              @set 'errors.code', true
            else
              @set 'message', Em.I18n.t('errors.unknown')

