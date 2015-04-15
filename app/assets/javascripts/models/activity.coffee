Caminio.Activity = Ember.Object.extend
  
  tName:        (->
    Em.I18n.t @get('name')
  ).property 'name'

  user:    (->
    if user = Caminio.User.store.find 'user', @get('user_id')
      return user
    null
  ).property 'user_id'

  appCssClass:  (->
    'fa fa-users'
  ).property ''
  
  ago: (->
    moment( @get 'created_at' ).fromNow()
  ).property 'created_at'
