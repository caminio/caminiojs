Caminio.Group = DS.Model.extend
  name:       DS.attr 'string'
  created_at: DS.attr 'date'
  users:      DS.hasMany 'users'
  color:      DS.attr 'string'
  
Caminio.GroupAdapter = Caminio.ApplicationAdapter.extend()