Caminio.SessionsSignupController = Ember.ObjectController.extend Caminio.Validations,

  pwConstraint: new RegExp("(?=.*[\w0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}")

  validate:
    email:
      required:
        message: Em.I18n.t('errors.email_required')
      match:
        regexp: /.+@.+/
        message: Em.I18n.t('errors.not_an_email_address')
    organization:
      required: ->
        return if !@.get('organizationEnabled') || !Em.isEmpty(@.get('organization'))
        Em.I18n.t('errors.organization_required')
    password:
      required:
        message: Em.I18n.t('errors.password_required')
      custom: ->
        return if @.get('pwConstraint').test(@.get('password'))
        Em.I18n.t('errors.password_policies_not_fulfilled')
    termsAccepted:
      required:
        message: Em.I18n.t('errors.accept_terms')

  pwStrength: (->
    return "width: 0" if Ember.isEmpty(@get('content.password'))
    return "width: 100%;" if @get('pwConstraint').test( @.get('content.password') ) && /[\W]{1,}/.test( @.get('content.password') ) && @.get('content.password').length > 8
    return "width: 70%;" if @get('pwConstraint').test( @.get('content.password') )
    return "width: 50%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    return "width: 30%;" if @get('content.password').match(/(?=.*\d)(?=.*[a-z])/)
    "width: 10%;"
  ).property('content.password')

  pwStrengthColor: (->
    return "progress-bar-danger" if Ember.isEmpty(@get('content.password'))
    return "progress-bar-success" if @.get('pwConstraint').test( @.get('content.password') )
    return "progress-bar-warning" if @.get('content.password').match(/(?=.*\d)(?=.*[a-z]).{6,}/)
    "progress-bar-danger"
  ).property('content.password')

  isOrganization: 'yes'

  organizationEnabled: (->
    @get('isOrganization') == 'yes'
  ).property 'isOrganization'

  actions:

    signupUser: =>
      return unless @isValid()
      Ember.$.post("#{Caminio.get('apiHost')}/users/signup", @getProperties('email','organization','password'))
        .then (res)=>
          @redirectToRoute 'sessions.enter_confirmation_key'
        .fail (err)->
          console.log err
