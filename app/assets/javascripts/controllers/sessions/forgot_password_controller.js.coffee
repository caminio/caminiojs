App.SessionsForgotPasswordController = App.SessionsController.extend

  email: ''
  message: Ember.I18n.t('forgot_info')
  valid: true

  actions:

    send_email: ->
      controller = @
      Ember.$.ajax(
        url: '/caminio/users/send_password_link',
        type: 'post',
        data:
          email: @.get('email')
      ).then (response)->
        controller.set('valid',true)
        controller.set('message', Em.I18n.t('check_inbox', {email: controller.get('email')}))
      .fail (response)->
        controller.set('valid',false)
        controller.set('message', Em.I18n.t('error.email_unknown', { email: controller.get('email') }))
