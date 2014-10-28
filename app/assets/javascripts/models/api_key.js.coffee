App.ApiKey = DS.Model.extend
  access_token:         DS.attr "string"
  expires_at:           DS.attr "date"
  user:                 DS.belongsTo "user", async: true
  permanent:            DS.attr 'boolean'
  name:                 DS.attr 'string'
  created_at:           DS.attr 'date'
  expired: (->
    console.log @get('expires_at')
    console.log @get('expires_at') < new Date()
    @get('expires_at') <= new Date()
  ).property 'expires_at'
