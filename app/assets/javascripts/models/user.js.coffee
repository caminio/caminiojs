App.User = DS.Model.extend
  firstname:              DS.attr "string"
  lastname:               DS.attr "string"
  email:                  DS.attr "string"
  password:               DS.attr "string"
  password_confirmation:  DS.attr "string"
  username:               DS.attr "string"
  organizational_units:   DS.belongsTo "organizational_unit", async: true
  imgSrc: (->
    return "/caminio/users/#{@.get('id')}/profile_picture"
  ).property('img')
  name: (->
    return @.get('username') unless Em.isEmpty(@.get('username'))
    name = @.get('firstname')
    name << ' ' unless Em.isEmpty(name)
    name << @.get('lastname')
    name
  ).property('username','firstname','lastname')

