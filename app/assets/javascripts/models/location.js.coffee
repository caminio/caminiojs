Caminio.Location = DS.Model.extend

  title:                          DS.attr('string')
  description:                    DS.attr('string')

  street:                         DS.attr('string')
  zip:                            DS.attr('string')
  city:                           DS.attr('string')
  country_code:                   DS.attr('string')
  state:                          DS.attr('string')

  building:                       DS.attr('string')
  stair:                          DS.attr('string')
  floor:                          DS.attr('string')
  room:                           DS.attr('string')
  gkz:                            DS.attr('string')
  addition:                       DS.attr('string')

  lat:                            DS.attr('string')
  lng:                            DS.attr('string')

  url:                            DS.attr 'string'
  phone:                          DS.attr 'string'
  email:                          DS.attr 'string'

  created_at:                     DS.attr 'date'
  updated_at:                     DS.attr 'date'

  tags:                           DS.attr 'array'

  shortAddress:  Em.computed ->
    str = if Em.isEmpty(@get('street')) then '' else @get('street')
    str += ', ' if str.length > 0
    unless Em.isEmpty @get('zip')
      str += @get('zip')
      str += ' '
    str += @get('city') unless Em.isEmpty(@get('city'))
    str
  .property 'street', 'city', 'zip'