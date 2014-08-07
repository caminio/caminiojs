App.App = DS.Model.extend
  name:                 DS.attr 'string'
  app_plans:            DS.hasMany 'app_plan'
  current_translation:  ->
    return @get('translations').findBy(o)
