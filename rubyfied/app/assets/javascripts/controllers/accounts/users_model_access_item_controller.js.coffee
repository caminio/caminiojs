App.AccountsUsersModelAccessItemController = Ember.ObjectController.extend
  newModelName: (->
    return false if @get('content.app_model.app.id') == @get('parentController.last_app_id')
    @get('parentController').set('last_app_id',@get('content.app_model.app.id'))
    true
  ).property ''
