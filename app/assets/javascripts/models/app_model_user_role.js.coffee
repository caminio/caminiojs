App.AppModelUserRole = DS.Model.extend
  app:                  DS.belongsTo 'app'
  user:                 DS.belongsTo 'user'
  organizational_unit:  DS.belongsTo 'organizational_unit'
  access_level:         DS.attr('integer', defaultValue: ACCESS.NONE)
