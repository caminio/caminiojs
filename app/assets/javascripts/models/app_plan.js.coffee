App.AppPlan = DS.Model.extend
  name:                 DS.attr 'string'
  app:                  DS.belongsTo 'app'
  users_amount:         DS.attr 'number'
  price:                DS.attr 'number'
  organizational_unit:  DS.belongsTo 'organizational_unit'
  usersQuota: (->
    "width: #{(@get('organizational_unit.users.length')/100*@get('users_amount'))}%"
  ).property 'users_amount', 'organizational_unit.users.length'
