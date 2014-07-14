App.ApiKey = DS.Model.extend
  access_token:         DS.attr "string"
  expires_at:           DS.attr "date"
  user:                 DS.belongsTo "user", async: true
