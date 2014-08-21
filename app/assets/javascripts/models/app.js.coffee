App.App = DS.Model.extend
  name:                 DS.attr 'string'
  app_plans:            DS.hasMany 'app_plan'
  app_models:           DS.hasMany 'app_model'
  current_plan:         null
  add_js:               DS.attr 'string'
  icon:                 DS.attr 'string'
  path:                 DS.attr 'string'
  current_plan_id:      DS.attr 'number'
  current_plan_id_observer: (->
    @set('current_plan', @.store.getById('app_plan', @get('current_plan_id')))
    @set('current_plan', @get('app_plans.firstObject')) unless @get('current_plan')
  ).observes 'current_plan_id'
  current_translation:  ->
    return @get('translations').findBy(o)
