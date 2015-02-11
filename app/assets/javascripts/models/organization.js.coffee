Caminio.Organization = DS.Model.extend
  name:             DS.attr 'string'
  fqdn:             DS.attr 'string'
  user_quota:       DS.attr 'number'
  users:            DS.hasMany 'users', inverse: 'organizations'
  app_plans:        DS.hasMany 'app_plans'
  
Caminio.OrganizationAdapter = Caminio.ApplicationAdapter.extend()