Caminio.GroupsNewController = Ember.ObjectController.extend Caminio.Validations,
  needs: ['application']

  notyMessages: true

  validate:
    name:
      required:
        message: Em.I18n.t('errors.group_name_required')

  actions:
    create: ->
      return unless @isValid()
      @get('content')
        .save()
        .then =>
          Em.$.noty.closeAll()
          noty( type: 'success', text: Em.I18n.t('saved', name: @get('content.name')) )
          @transitionToRoute 'groups.index'

