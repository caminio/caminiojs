App.AppController = Ember.ObjectController.extend
  nameTranslation: (->
    Ember.I18n.t("apps.#{@.get('content.name').toLowerCase()}")
  ).property('content.name'),
  appPath: (->
    "##{@.get('content.path')}"
  ).property('content.path')
