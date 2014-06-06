module.exports.mailer = {
  
  from: 'camin.io <no-reply@example.com>',

  host: 'smtprelaypool.ispgateway.de',

  port: 465,

  secureConnection: true,
  
  auth: {
    user: 'no-reply@example.com',
    pass: 'XXX'
  },

  support: 'support@camin.io',

  goodbye: 'have a nice day,\n  caminio'

};