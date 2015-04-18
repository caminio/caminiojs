Caminio.IndexRoute = Caminio.AuthenticatedRoute.extend
  beforeModel: ->
    @transitionTo 'ticketeer.index'