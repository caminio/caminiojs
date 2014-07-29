App.OrganizationalUnit = DS.Model.extend
  name:               DS.attr "string"
  organizational_unit_members:              DS.hasMany "organizational_unit_member"

