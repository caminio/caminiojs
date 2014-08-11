App.AppModel = DS.Model.extend
  name:                 DS.attr 'string'
  app:                  DS.belongsTo 'app'
