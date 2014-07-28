App.SessionsSignupController = Ember.Controller.extend

  email: ''
  password: ''
  domain: ''

  actions:

    signupNow: ->
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
        controller.set('errorMessage', Em.I18n.t('error.email_unknown', { email: controller.get('email') }))
