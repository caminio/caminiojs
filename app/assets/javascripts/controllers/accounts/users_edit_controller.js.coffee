App.AccountsUsersEditController = Em.ObjectController.extend App.Validations,
  validate:
    email:
      required:
        message: Em.I18n.t('errors.required.email')
      match:
        regexp: /[@]{1}/
        message: Em.I18n.t('errors.not_an_email_address')

  availableLangs: AVAILABLE_LANGS
  plans: null

  actions:
    save: ->
      return unless @.isValid()
      controller = @
      $.ajax
        url: '/caminio/users/'+@get('content.id')
        type: 'put'
        data: 
          user: @get('content').toJSON()
          app_model_user_roles: @get('content.app_model_user_roles').map( (ur)-> { app_model_id: ur.get('app_model.id'), access_level: ur.get('access_level') } )
      .then (user)->
        toastr.info Em.I18n.t('accounts.users.rules_saved', name: controller.get('content.name'))
        controller.transitionToRoute 'accounts.users'
