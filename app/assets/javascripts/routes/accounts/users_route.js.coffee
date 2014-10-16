App.AccountsUsersRoute = App.ApplicationRoute.extend
  auth: true
  setupController: (controller,model)->
    @_super(controller,model)
    @store.find('user', t: new Date())
      .then (users)->
        controller.set('content', Em.A(users))
    currentOuCookie = Ember.$.cookie 'caminio-session-ou'
    ou = App.get('currentUser').get('organizational_units').findBy('id', currentOuCookie )
    App.set('currentOu', ou)
