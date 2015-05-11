Caminio.IndexRoute = Caminio.AuthenticatedRoute.extend
  beforeModel: ->
    @transitionTo 'sessions.index'