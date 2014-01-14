/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var nodemailer = require('nodemailer')
  , util = require('util')
  , logger = require('./logger');

/**

A wrapper class for nodemailer providing
some extra functionality.

@class Mailer

**/

var smtpTransport
  , config;

module.exports = {
  send: sendMail,
  init: initMailer
}

/**

send an email with given options

@method send
@param {Object} options
@param {String} options.from
@param {String} options.subject
@param {String} options.content
@param {Function} callback
@param {Object} callback.err
@param {String} callback.message

**/
function sendMail( options, callback ){
  options.from = options.from || config.from;
  if( process.env.NODE_ENV === 'production' )
    smtpTransport.sendMail( options, callback );
  else{
    logger.info('mailer', 'would send email to ' + util.inspect(options.to) );
    logger.info('mailer', 'with other options ' + util.inspect(options) );
    callback( null, 'sent');
  }

}

function initMailer( _config ){
  config = _config.mailerSettings;
  console.log(config);
  smtpTransport = nodemailer.createTransport( 'SMTP', config );
}
