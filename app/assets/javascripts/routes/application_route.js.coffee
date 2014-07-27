App.ApplicationRoute = Ember.Route.extend

  actions:

    openModal: (modalName)->
      @.render modalName, into: 'application', outlet: 'modal'

    closeModal: ->
      @.disconnectOutlet outlet: 'modal', parentView: 'application'
