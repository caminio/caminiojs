Caminio.Activity = DS.Model.extend
  name:         DS.attr 'string'
  
  tName:        (->
    Em.I18n.t @get('name')
  ).property 'name'
  
  appCssClass:  (->
    'fa fa-users'
  ).property ''
  
  ago: (->
    moment( @get 'created_at' ).fromNow()
  ).property 'created_at'

  created_at:   DS.attr 'date'
  user:         DS.belongsTo 'user', async: true

  item_id:      DS.attr 'string'
  item_type:    DS.attr 'string'

Caminio.ActivityAdapter = Caminio.ApplicationAdapter.extend()