UserDummy = Ember.Object.extend
  password: ''

App.SessionsResetPasswordController = Ember.ObjectController.extend App.Validations,

  needs: ['sessions']
  user_id: null
  confirmation_key: null

  content: UserDummy.create()

  pwConstraint: new RegExp("(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}")

  validate:
    password:
      required:
        message: Em.I18n.t('errors.required.password')
      custom: ->
        return if @.get('pwConstraint').test(@.get('content.password'))
        Em.I18n.t('errors.password_policies_not_fulfilled')

  pwStrength: (->
    return "width: 100%;" if @get('pwConstraint').test( @.get('content.password') ) && /[\W]{1,}/.test( @.get('content.password') ) && @.get('content.password').length > 8
    return "width: 70%;" if @get('pwConstraint').test( @.get('content.password') )
    return "width: 50%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    return "width: 30%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z])/)
    "width: 10%;"
  ).property('content.password')

  pwStrengthColor: (->
    return "progress-bar-success" if @.get('pwConstraint').test( @.get('content.password') )
    return "progress-bar-warning" if @.get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    "progress-bar-danger"
  ).property('content.password')

  actions:
    save: ->
      return unless @.isValid()
      controller = @
      Ember.$.ajax(
        url: '/caminio/users/'+@get('user_id')+'/reset_password',
        type: 'post',
        data:
          password: @get('content.password')
          confirmation_key: @get('confirmation_key')
      ).then (response)->
        controller.get('controllers.sessions').authenticate(response.api_key)
        toastr.info Em.I18n.t('accounts.users.password_saved')
      .fail (error)->
        controller.set('valid', false)
        if error.responseJSON.error && error.responseJSON.error.indexOf('exists') >= 0
          return controller.set('message', Em.I18n.t('error.email_exists', { email: controller.get('content.email') }))
        controller.set('message', Em.I18n.t('error.email_error', { email: controller.get('content.email') }))

