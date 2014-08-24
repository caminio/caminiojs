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
          app_model_user_roles: @get('content.app_model_user_roles').map( (ur)-> { app_model_id: ur.get('app_model.id'), access_level: ur.get('access_level') } )
      .then (user)->
        toastr.info Em.I18n.t('accounts.users.created', name: controller.get('content.name'))
        controller.transitionToRoute 'accounts.users'
