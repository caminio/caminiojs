App.AccessRule = DS.Model.extend
  can_write: DS.attr 'boolean'
  can_share: DS.attr 'boolean'
  can_delete: DS.attr 'boolean'
  user: DS.belongsTo 'user'
  organizational_unit: DS.belongsTo 'organizational_unit'
  app: DS.belongsTo 'app'
