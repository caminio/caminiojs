App.AppController = Ember.ObjectController.extend
  nameTranslation: (->
    Ember.I18n.t("#{@.get('content.name').toLowerCase()}.app_title")
  ).property('content.name'),
  appPath: (->
    "#{@.get('content.url')}"
  ).property('content.url')
