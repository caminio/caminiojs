Caminio.Organization = DS.Model.extend
  name:             DS.attr 'string'
  fqdn:             DS.attr 'string'
  user_quota:       DS.attr 'number'
  users:            DS.hasMany 'users', inverse: 'organizations'
  
Caminio.OrganizationAdapter = Caminio.ApplicationAdapter.extend()