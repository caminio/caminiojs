App.SessionsForgotPasswordController = App.SessionsController.extend

  email: ''
  message: Ember.I18n.t('forgot_info')
  valid: true

  actions:

    send_email: ->
      @.set('errorMessage',null)
      controller = @
      Ember.$.ajax(
        url: '/caminio/users/reset_password',
        type: 'post',
        data:
          email: @.get('email')
      ).then (response)->
        controller.set('message', response.message)
      .fail (response)->
        controller.set('error',true)
        controller.set('message', Em.I18n.t('error.email_unknown', { email: controller.get('email') }))
