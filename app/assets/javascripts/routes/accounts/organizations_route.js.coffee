App.AccountsOrganizationsRoute = App.AuthRoute.extend
  model: ->
    @.controllerFor('sessions').get('currentUser')
  setupController: (controller,model)->
    controller.set('newOu',@store.createRecord('organizational_unit'))
