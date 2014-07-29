App.OrganizationalUnitMember = DS.Model.extend

  user: DS.belongsTo 'user'
  organizational_unit: DS.belongsTo 'organizational_unit'

  relationshipsLoaded: ( ->
    @get('user.isLoaded') and @get('organizational_unit.isLoaded')
  ).property 'user.isLoaded', 'organizational_unit.isLoaded'
