App.AppController = Ember.ObjectController.extend
  nameTranslation: (->
    inflector = new Ember.Inflector(Ember.Inflector.defaultRules)
    console.log "translation for #{@get('content.name')} #{Em.I18n.t('messages')}"
    Em.I18n.t( inflector.pluralize( @.get('content.name').toLowerCase() ) )
  ).property('content.name'),
  appPath: (->
    "##{@.get('content.path')}"
  ).property('content.path')
