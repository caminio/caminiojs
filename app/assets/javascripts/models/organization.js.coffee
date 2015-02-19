Caminio.Organization = DS.Model.extend
  name:             DS.attr 'string'
  fqdn:             DS.attr 'string'
  user_quota:       DS.attr 'number'
  users:            DS.hasMany 'users', inverse: 'organizations'
  app_bills:        DS.hasMany 'app_bills'
  last_paid_bill:   DS.belongsTo 'app_bill'
  
Caminio.OrganizationAdapter = Caminio.ApplicationAdapter.extend()