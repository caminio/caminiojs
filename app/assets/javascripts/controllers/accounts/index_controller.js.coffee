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

    repairRules: ->
      $.post('/caminio/access_rules/repair')
        .then (status)->
          toastr.info Em.I18n.t('accounts.user.access.rules_repaired')
          App.get('currentUser').reload()
        .fail (err)->
          console.log err
