Caminio.ApiKey = DS.Model.extend
  token:        DS.attr 'string'
  expires_at:   DS.attr 'date'
  user:         DS.belongsTo 'user', async: true
  ip_addresses: DS.attr 'string'
  name:         DS.attr 'string'
