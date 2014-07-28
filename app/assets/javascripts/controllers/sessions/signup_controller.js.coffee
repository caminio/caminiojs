App.SessionsSignupController = Ember.Controller.extend App.Validations,

  email: ''
  password: ''
  companyName: ''
  termsAccepted: false
  isCompany: true

  pwConstraint: new RegExp("(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}")

  validate:
    termsAccepted:
      required:
        message: Em.I18n.t('errors.accept_terms')
    companyName:
      required: ->
        return unless @.get('isCompany') || !Em.isEmpty(@.get('companyName'))
        Em.I18n.t('errors.required.company_name')
    email:
      required:
        message: Em.I18n.t('errors.required.email')
      match:
        regexp: /[@]{1}/
        message: Em.I18n.t('errors.not_an_email_address')
    password:
      required:
        message: Em.I18n.t('errors.required.password')
      custom: ->
        return if @.get('pwConstraint').test(@.get('password'))
        Em.I18n.t('errors.password_policies_not_fulfilled')

  pwStrength: (->
    return "width: 100%;" if @.get('pwConstraint').test( @.get('password') ) && /[\W]{1,}/.test( @.get('password') ) && @.get('password').length > 8
    return "width: 70%;" if @.get('pwConstraint').test( @.get('password') )
    return "width: 50%;" if @.get('password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    return "width: 30%;" if @.get('password').match(/(?=.*\d)(?=.*[a-z])/)
    "width: 10%;"
  ).property('password')

  pwStrengthColor: (->
    return "progress-bar-success" if @.get('pwConstraint').test( @.get('password') )
    return "progress-bar-warning" if @.get('password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    "progress-bar-danger"
  ).property('password')

  actions:

    toggleTermsAccepted: ->
      @.set('termsAccepted', !@.get('termsAccepted'))
    toggleCompany: (company)->
      @.set('isCompany', company)
    signupNow: ->
      return unless @.isValid()
      controller = @
      Ember.$.ajax(
        url: '/caminio/users/signup',
        type: 'post',
        data:
          email: @.get('email')
      ).then (response)->
        controller.set('message', response.message)
      .fail (response)->
        controller.set('errorMessage', Em.I18n.t('error.email_unknown', { email: controller.get('email') }))
