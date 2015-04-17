Caminio.SessionsResetPasswordController = Ember.ObjectController.extend Caminio.Validations,

  needs: ['sessions']

  pwConstraint: new RegExp("(?=.*[\w0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}")

  validate:
    password:
      required:
        message: Em.I18n.t('errors.password_required')
      custom: ->
        return if @.get('pwConstraint').test(@.get('password'))
        Em.I18n.t('errors.password_policies_not_fulfilled')

  pwStrength: (->
    return "width: 0" if Ember.isEmpty(@get('content.password'))
    return "width: 100%;" if @get('pwConstraint').test( @.get('content.password') ) && /[\W]{1,}/.test( @.get('content.password') ) && @.get('content.password').length > 8
    return "width: 70%;" if @get('pwConstraint').test( @.get('content.password') )
    return "width: 50%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    return "width: 30%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z])/)
    "width: 10%;"
  ).property('content.password')

  pwStrengthColor: (->
    return "progress-bar-danger" if Ember.isEmpty(@get('content.password'))
    return "progress-bar-success" if @.get('pwConstraint').test( @.get('content.password') )
    return "progress-bar-warning" if @.get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    "progress-bar-danger"
  ).property('content.password')


  actions:

    resetPassword: ->
      return unless @isValid()
      Ember.$.post("#{Caminio.get('apiHost')}/users/#{@get('content.id')}/reset_password", @getProperties('password', 'confirmation_key'))
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
              noty
                text: Em.I18n.t('password_has_been_saved')
                type: 'success'
        .fail (err)=>
          if err.status == 404
            @set 'valid', false
            @set 'message', Em.I18n.t('errors.key_invalid_or_expired')
          else
            console.log('err', err)
            @set 'message', err.responseJSON.details

