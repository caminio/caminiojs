Caminio.ApiKeysIndexController = Ember.ArrayController.extend

  needs: ['application']
  
  filter: {}

  tableBridge: null

  tableColumns: Em.A([
    { name: 'name', i18n: 'api_key.name' }
    { name: 'created_by', i18n: 'created_by' }
    { name: 'created_at', i18n: 'created_at' }
    { name: 'expires_at', i18n: 'expires_at' }
  ])

  tableOrder: ['name']