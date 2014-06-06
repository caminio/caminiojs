/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

/**
 * @class mailer
 */
module.exports = function( caminio ){  

  'use strict';

  return {
    send: send
  };

  var nodemailer      = require('nodemailer');
  var fs              = require('fs');
  var join            = require('path').join;
  var ejs             = require('ejs');

  /**
   * send an email through the nodemailer wrapper
   *
   * @method send
   * @param {String,Array} recipients
   * @param {String} subject
   * @param {String} templateName [optional]
   * @param {Object} options
   * @param {Object} options.locals
   * @param {Object} options.text
   * @param {Function} callback
   * @param {Object} callback.err
   */
  function send( recipients, subject, templateName, options, callback ){
    if( recipients instanceof Array )
      recipients = recipients.join(',');
    if( typeof(templateName) === 'object' && arguments.length < 5 ){
      if( typeof(options) === 'function' )
        callback = options;
      options = templateName;
      templateName = null;
    }
    if( caminio.env !== 'production' ){
      caminio.logger.debug('sending mail to: ',recipients);
      caminio.logger.debug('subject:', subject);
      caminio.logger.debug( '\n', templateName ? processTemplate(templateName,options.locals) : options.text );
    } else {
      buildSmtpTransport().sendMail({
        from: options.from || caminio.config.mailer.from,
        to: recipients,
        subject: subject,
        text: (templateName ? processTemplate(templateName,options.locals) : options.text)
      });
    }
    callback(null);
  }

  /**
   * @method buildSmtpTransport
   * @private
   */
  function buildSmtpTransport(){
    return nodemailer.createTransport( 'SMTP', {
        host: caminio.config.mailer.host,
        port: caminio.config.mailer.port,
        secureConnection: caminio.config.mailer.secureConnection,
        auth: {
          user: caminio.config.mailer.auth.user,
          pass: caminio.config.mailer.auth.pass
        }
      });
  }

  /**
   * processes given template
   */
  function processTemplate( tmpl, locals ){
    var tmplStr = getTemplate( attachUserLang2TemplateName( tmpl, locals ) );
    if( !tmplStr )
      tmplStr = getTemplate( tmpl );
    caminio.logger.debug('mailer template used:', tmplStr);
    locals = addSystemVariables(locals);
    caminio.logger.debug('locals:', locals);
    if( tmplStr )
      return ejs.compile( fs.readFileSync(tmplStr).toString(), { filename: tmplStr } )(locals);
  }

  /**
   * find and get a template matching the given path
   * the .ejs suffix is appended automatically. Currently
   * there is only .ejs rendering supported.
   *
   */
  function getTemplate( tmpl ){

    var res;
    caminio.views.paths.forEach( function(p){
      var absPath = join( p, 'mailers', tmpl+'.ejs' );
      if( fs.existsSync(absPath) )
        res = absPath;
    });
    return res;

  }

  /**
   * attaches the user's preferred language to the template name
   * if any
   *
   * this should generate something like:
   * auth/reset_password_de
   *
   */
  function attachUserLang2TemplateName( templateName, locals ){
    if( !('user' in locals) )
      return templateName;
    if( !locals.user.lang )
      return templateName;
    return templateName + '.' + locals.user.lang;
  }

  /**
   * adds some system variables to the locals
   * object which is being feed to the ejs.compile
   * method in order to process the template
   */
  function addSystemVariables( locals ){
    locals.support = caminio.config.mailer.support;
    locals.goodbye = caminio.config.mailer.goodbye;
    return locals;
  }


};