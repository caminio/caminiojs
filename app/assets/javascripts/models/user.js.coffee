App.User = DS.Model.extend
  firstname:                      DS.attr "string"
  username:                       DS.attr "string"
  lastname:                       DS.attr "string"
  email:                          DS.attr "string"
  phone:                          DS.attr "string"
  description:                    DS.attr "string"
  password:                       DS.attr "string"
  password_confirmation:          DS.attr "string"
  settings:                       DS.attr "object"
  organizational_units:           DS.hasMany "organizational_unit"
  avatar_thumb:                   DS.attr "string"

  current_organizational_unit:      (->
    @get('organizational_units.firstObject')
  ).property 'organizational_units'
  name: (->
    return @.get('username') unless Em.isEmpty(@.get('username'))
    name = @.get('firstname')
    name << ' ' unless Em.isEmpty(name)
    name << @.get('lastname')
    name
  ).property('username','firstname','lastname')
  name_or_email: (->
    return @.get('name') unless Em.isEmpty @.get('name')
    @.get('email')
  ).property('username','firstname','lastname','email')
