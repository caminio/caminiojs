Caminio.UsersNewController = Ember.ObjectController.extend Caminio.Validations,

  needs: ['application', 'sessions']

  notyMessages: true

  validate:
    email:
      required:
        message: Em.I18n.t('errors.email_required')
      match:
        regexp: /.+@.+/
        message: Em.I18n.t('errors.not_an_email_address')

  actions:
    create: ->
      return unless @isValid()
      @get('content')
        .save()
        .then =>
          Em.$.noty.closeAll()
          noty( type: 'success', text: Em.I18n.t('saved', name: @get('content.name')), timeout: 2000 )
          @transitionToRoute 'users.index'

