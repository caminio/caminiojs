App.User = DS.Model.extend
  firstname:              DS.attr "string"
  lastname:               DS.attr "string"
  email:                  DS.attr "string"
  password:               DS.attr "string"
  password_confirmation:  DS.attr "string"
  # api_keys:               DS.hasMany "apiKey"

