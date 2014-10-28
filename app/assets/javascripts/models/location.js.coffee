App.Location = DS.Model.extend
  slug:               DS.attr 'string'
  title:              DS.attr 'string'
  description:        DS.attr 'string'

  street:             DS.attr 'string'
  zip:                DS.attr 'string'
  city:               DS.attr 'string'
  country:            DS.attr 'string'
  state:              DS.attr 'string'

  phone:              DS.attr 'string'
  email:              DS.attr 'string'
  url:                DS.attr 'string'

  lng:                DS.attr 'string'
  lat:                DS.attr 'string'
