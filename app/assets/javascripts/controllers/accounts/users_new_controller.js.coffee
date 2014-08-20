App.AccountsUsersNewController = Em.ObjectController.extend App.Validations,
  validate:
    email:
      required:
        message: Em.I18n.t('errors.required.email')
      match:
        regexp: /[@]{1}/
        message: Em.I18n.t('errors.not_an_email_address')

  availableLangs: AVAILABLE_LANGS
  actions:
    create: ->
      return unless @.isValid()
      controller = @
      @get('content')
        .save()
        .then (user)->
          toastr.info Em.I18n.t('accounts.users.created', name: user.get('name'))
          controller.transitionToRoute 'accounts/users/edit', user.id
