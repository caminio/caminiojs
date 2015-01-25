Caminio.GroupsAddMemberController = Ember.ObjectController.extend Caminio.Validations,
  needs: ['application']

  name: ''

  actions:
    add: ->
      return unless @isValid()
      @get('content')
        .save()
        .then =>
          Em.$.noty.closeAll()
          noty( type: 'success', text: Em.I18n.t('saved', name: @get('content.name')) )
          @transitionToRoute 'groups.index'

