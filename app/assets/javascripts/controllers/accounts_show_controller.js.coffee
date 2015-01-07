Caminio.AccountsShowController = Ember.ObjectController.extend
  needs: ['application']

  actions:
    save: (callback, scope)->
      @get('content')
        .save()
        .then ->
          callback.call(scope)

Caminio.AccountsMineController = Caminio.AccountsShowController.extend()
