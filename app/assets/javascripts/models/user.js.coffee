App.User = DS.Model.extend
  locale:                         DS.attr "string"
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
  cur_password:                   DS.attr "string"

  name: (->
    return @get('username') unless Em.isEmpty(@get('username'))
    name = ""
    name += @get('firstname') unless Em.isEmpty(@get('firstname'))
    unless Em.isEmpty(@get('lastname'))
      name += " " unless Em.isEmpty(name)
      name += " " + @get('lastname')
    name = @get('email') if Em.isEmpty(name)
    name
  ).property('username','firstname','lastname')

  name_or_email: (->
    return @.get('name') unless Em.isEmpty @.get('name')
    @.get('email')
  ).property('username','firstname','lastname','email')

  formattedLastLoginAt: (->
    return moment(@get('last_login_at')).fromNow()
  ).property 'last_login_at'
