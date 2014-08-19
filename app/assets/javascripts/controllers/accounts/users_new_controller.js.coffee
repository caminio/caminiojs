App.AccountsUsersNewController = Em.ObjectController.extend
  actions:
    create: ->
      controller = @
      @get('content')
        .save()
        .then (user)->
          toastr.info Em.I18n.t('accounts.users.created', name: user.get('name'))
          controller.transitionToRoute 'accounts/users/edit', user.id
