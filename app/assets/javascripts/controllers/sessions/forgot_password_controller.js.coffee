App.SessionsForgotPasswordController = Ember.Controller.extend

  email: ''
  message: Ember.I18n.t('forgot_info')

  actions:

    send_email: ->
      controller = @
      Ember.$.ajax(
        url: '/caminio/users/reset_password',
        type: 'post',
        data:
          email: @.get('email')
      ).then (response)->
        controller.set('message', response.message);
