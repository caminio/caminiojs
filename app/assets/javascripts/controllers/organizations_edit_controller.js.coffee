Caminio.OrganizationsEditController = Ember.ObjectController.extend Caminio.Validations,
  needs: ['application']

  notyMessages: true

  actions:
    save: (callback, scope)->
      @get('content')
        .save()
        .then ->
          callback.call(scope)
