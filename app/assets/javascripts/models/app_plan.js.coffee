App.AppPlan = DS.Model.extend
  name:                 DS.attr 'string'
  app:                  DS.belongsTo 'app'
  user_quota:         DS.attr 'number'
  price:                DS.attr 'number'
  organizational_unit:  DS.belongsTo 'organizational_unit'
  usersQuota: (->
    "width: #{(@get('organizational_unit.users.length')/100*@get('user_quota'))}%"
  ).property 'user_quota', 'organizational_unit.users.length'
