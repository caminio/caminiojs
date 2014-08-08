App.AppModel = DS.Model.extend
  name:                 DS.attr 'string'
  app:                  DS.belongsTo 'app'
  icon:                 DS.attr 'string'
  path:                 DS.attr 'string'
  add_js:               DS.attr 'string'
