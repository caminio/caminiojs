App.AccountsUsersChangePasswordController = Em.ObjectController.extend App.Validations,
  pwConstraint: new RegExp("(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}")

  validate:
    password:
      required:
        message: Em.I18n.t('accounts.users.errors.new_missing')
      custom: ->
        return if @.get('pwConstraint').test(@get('content.password'))
        Em.I18n.t('errors.password_policies_not_fulfilled')
    cur_password:
      required:
        message: Em.I18n.t('accounts.users.errors.current_missing')
    password_confirmation:
      required: ->
        return if @get('content.password') == @get('content.password_confirmation')
        Em.I18n.t('accounts.users.errors.confirmation_mismatch')

  pwStrength: (->
    return "width: 10%;" unless @get('content.password')
    return "width: 100%;" if @get('pwConstraint').test( @.get('content.password') ) && /[\W]{1,}/.test( @.get('content.password') ) && @.get('content.password').length > 8
    return "width: 70%;" if @get('pwConstraint').test( @.get('content.password') )
    return "width: 50%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    return "width: 30%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z])/)
    "width: 10%;"
  ).property('content.password')

  pwStrengthColor: (->
    return "progress-bar-danger" unless @get('content.password')
    return "progress-bar-success" if @.get('pwConstraint').test( @.get('content.password') )
    return "progress-bar-warning" if @.get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    "progress-bar-danger"
  ).property('content.password')


  actions:
    save: ->
      return unless @.isValid()
      controller = @
      @get('content')
        .save()
        .then (user)->
          toastr.success Em.I18n.t('accounts.users.password_saved')
          controller.transitionToRoute 'accounts.index'
        .catch (err)->
          console.error err
          toastr.error Em.I18n.t('accounts.user.password_saving_failed')
