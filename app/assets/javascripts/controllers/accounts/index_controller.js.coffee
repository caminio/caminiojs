App.AccountsIndexController = Em.ObjectController.extend

  availableLangs: AVAILABLE_LANGS

  actions:

    save: ->
      @get('content')
        .save()
        .then (user)->
          toastr.success( Em.I18n.t('accounts.users.saved', name: user.get('name')))
        .catch (err)->
          toastr.error( Em.I18n.t('accounts.users.saving_failed', name: user.get('name')))
