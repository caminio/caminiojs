App.App = DS.Model.extend
  name:                 DS.attr 'string'
  current_translation:  ->
    return @get('translations').findBy(o)
