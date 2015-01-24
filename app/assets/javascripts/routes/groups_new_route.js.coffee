Caminio.GroupsNewRoute = Caminio.AuthenticatedRoute.extend Caminio.DestroyOnCancelMixin,
  model: ->
    @store.createRecord('group')

