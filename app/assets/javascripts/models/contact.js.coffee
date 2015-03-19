Caminio.Contact   = DS.Model.extend
  firstname:                  DS.attr 'string'
  lastname:                   DS.attr 'string'
  company:                    DS.attr 'string'
  
  degree:                     DS.attr('string')
  gender:                     DS.attr('string')
  email:                      DS.attr('string')
  phone:                      DS.attr('string')
  # locale:                     DS.attr('string')
  billing:                    DS.attr('boolean')
  shipping:                   DS.attr('string')

  # location:                   DS.belongsTo('location')
  # ticketeer_contact:         DS.belongsTo('ticketeer_contact')