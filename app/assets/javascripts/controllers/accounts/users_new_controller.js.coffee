App.AccountsUsersNewController = App.AccountsUsersEditController.extend
  actions:
    create: ->
      return unless @.isValid()
      controller = @
      $.ajax
        url: '/caminio/users'
        type: 'post'
        data: 
          user: @get('content').toJSON()
      .then (user)->
        toastr.info Em.I18n.t('accounts.users.created', name: controller.get('content.name'))
        controller.transitionToRoute 'accounts.users'
      .fail (err)->
        toastr.error Em.I18n.t('accounts.users.errors.amount_exceeded')

