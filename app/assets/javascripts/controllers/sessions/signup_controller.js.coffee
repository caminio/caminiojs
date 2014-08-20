UserDummy = Ember.Object.extend
  email: ''
  password: ''
  companyName: ''
  locale: LANG
  termsAccepted: false
  isCompany: true


App.SessionsSignupController = Ember.ObjectController.extend App.Validations,

  needs: ['sessions']
  availableLangs: AVAILABLE_LANGS
  content: UserDummy.create()

  pwConstraint: new RegExp("(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}")

  validate:
    termsAccepted:
      required:
        message: Em.I18n.t('errors.accept_terms')
    companyName:
      required: ->
        return if !@.get('isCompany') || !Em.isEmpty(@.get('companyName'))
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
    return "width: 100%;" if @get('pwConstraint').test( @.get('content.password') ) && /[\W]{1,}/.test( @.get('content.password') ) && @.get('content.password').length > 8
    return "width: 70%;" if @get('pwConstraint').test( @.get('content.password') )
    return "width: 50%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    return "width: 30%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z])/)
    "width: 10%;"
  ).property('content.password')

  pwStrengthColor: (->
    return "progress-bar-success" if @.get('pwConstraint').test( @.get('content.password') )
    return "progress-bar-warning" if @.get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    "progress-bar-danger"
  ).property('content.password')
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
          email: @get('content.email')
          password: @get('content.password')
          company_name: @get('content.companyName')
          locale: @get('content.locale')
      ).then (response)->
        controller.get('controllers.sessions').authenticate(response.api_key)
      .fail (error)->
        controller.set('valid', false)
        if error.responseJSON.error && error.responseJSON.error.indexOf('exists') >= 0
          return controller.set('message', Em.I18n.t('error.email_exists', { email: controller.get('content.email') }))
        controller.set('message', Em.I18n.t('error.email_error', { email: controller.get('content.email') }))
