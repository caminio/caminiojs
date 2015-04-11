Caminio.ApiKeysIndexController = Ember.ArrayController.extend

  needs: ['application']
  
  filter: {}

  tableBridge: null

  tableColumns: Em.A([
    { name: 'name', i18n: 'api_key.name' }
    { name: 'ip_addresses', i18n: 'api_key.ip_addresses' }
    { name: 'created_by.name', i18n: 'created_by' }
    { name: 'created_at', type: 'datetime', i18n: 'created_at' }
    { name: 'expires_at', type: 'dateTo', i18n: 'expires_at' }
  ])

  tableOrder: ['name']

  actions:

    deleteRow: (row)->
      row
        .destroyRecord()
        .then ->
          noty
            text: Em.I18n.t('api_key.deleted', name: row.get('name'))
            type: 'success'
        .catch (err)->
          console.log 'error:', err
          Caminio.NotyUnknownError(err)