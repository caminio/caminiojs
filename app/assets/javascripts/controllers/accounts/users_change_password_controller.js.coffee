App.AccountsUsersChangePasswordController = Em.ObjectController.extend App.Validations,
  pwConstraint: new RegExp("(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}")

  validate:
    password:
      required:
        message: Em.I18n.t('errors.required.password')
      custom: ->
        return if @.get('pwConstraint').test(@.get('password'))
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
      @get('content')
        .save()
        .then (user)->
          toastr.info Em.I18n.t('accounts.users.saved', name: controller.get('content.name'))
          controller.transitionToRoute 'accounts.users'
