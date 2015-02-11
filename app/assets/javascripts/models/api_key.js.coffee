Caminio.ApiKey = DS.Model.extend
  token:        DS.attr 'string'
  expires_at:   DS.attr 'date'
  user:         DS.belongsTo 'user', async: true
