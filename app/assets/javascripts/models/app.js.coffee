App.App = DS.Model.extend
  name:                 DS.attr 'string'
  app_plans:            DS.hasMany 'app_plan'
  current_plan:         DS.belongsTo 'app_plan'
  add_js:               DS.attr 'string'
  icon:                 DS.attr 'string'
  path:                 DS.attr 'string'
  current_plan_id:      DS.attr 'number'
  current_plan_id_observer: (->
    @set('current_plan', @.store.getById('app_plan', @get('current_plan_id')))
  ).observes 'current_plan_id'
  current_translation:  ->
    return @get('translations').findBy(o)
