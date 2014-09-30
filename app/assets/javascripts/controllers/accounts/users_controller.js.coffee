App.AccountsUsersController = Em.ObjectController.extend

  actions:

    # editUser: (user)->
    #   @transitionToRoute('accounts.users.edit', user.get('id'))
    #
    uninviteUser: (user)->
      if user.id == App.get('currentUser.id')
        return bootbox.alert Em.I18n.t('accounts.users.cannot_remove_yourself')
      bootbox.confirm Em.I18n.t('accounts.users.really_uninvite', name: user.get('name_or_email')), (result)->
        if result
          user
            .destroyRecord()
            .then (user)->
              toastr.info Em.I18n.t('accounts.users.uninvited', name: user.get('name_or_email'))
            .catch (error)->
              toastr.error error.responseJSON

    addUser: ->
      @transitionToRoute('accounts.users.new')

