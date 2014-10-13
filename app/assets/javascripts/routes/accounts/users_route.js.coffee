App.AccountsUsersRoute = App.ApplicationRoute.extend
  auth: true
  model: ->
    @store.find 'user'
  setupController: (controller,model)->
    @_super(controller,model)
    currentOuCookie = Ember.$.cookie 'caminio-session-ou'
    ou = App.get('currentUser').get('organizational_units').findBy('id', currentOuCookie )
    App.set('currentOu', ou)
