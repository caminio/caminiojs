App.AccountsOrganizationsRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    @.controllerFor('sessions').get('currentUser')
  setupController: (controller,model)->
    @_super(controller,model)
    controller.set 'newOu', @store.createRecord('organizational_unit')
    controller.set 'currentOrganizationalUnit', (if App.get('currentOu.name') == 'private' then null else App.get('currentOu') )
