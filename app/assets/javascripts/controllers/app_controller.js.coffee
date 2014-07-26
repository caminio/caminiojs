App.AppController = Ember.ObjectController.extend
  nameTranslation: (->
    Ember.I18n.t( @.get('content.name') )
  ).property('content.name'),
  appPath: (->
    "##{@.get('content.path')}"
  ).property('content.path')
