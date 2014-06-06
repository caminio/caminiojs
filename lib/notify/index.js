/** 
 * @Author: David Reinisch
 * @Company: TASTENWERK e.U.
 * @Copyright: 2014 by TASTENWERK
 * @License: Commercial
 *
 * @Date:   2014-06-06 12:07:16
 *
 * @Last Modified by:   David Reinisch
 * @Last Modified time: 2014-06-06 16:12:06
 *
 */

module.exports = function ( caminio ) {

  'use strict';

  var services = {};

  /** 
   *  @constructor Notify
   *  @param namespace { String }
   *  @param unit { String }
   *  @param user { Object }
   *  @example
   *  The service that should be called must be registered:
   *      exampleMailer = require('exampleMailer')
   *      Notify.registerService('mailer', exampleMailer)
   *  The user that calls that service must have the namespace in its notify 
   *  settings:
   *      user = { notify: { namespace: 'aNamespace' } }
   *  To run it the Notify just needs to be applied with the right settings:
   *      Notify( 'aNamespace', 'mailer', user, [ otherSettings ... ], callback )
   *      
   */
  function Notify( namespace, unit, user ){
    var args = Array.prototype.slice.call(arguments);
    args.splice(0,2);

    checkNamespace( namespace, user );

    var service = services[unit];

    if( !service )
      throw new Error('UNREGISTERED SERVICE: ' + unit );

    service.send.apply( undefined, args );
  }

  /** 
   *  @method registerService
   *  @param key { String }
   *  @param service { Function } Must have a send method to be activated
   */
  Notify.registerService = function( key, service ){
    services[key] = service;
  };

  /**
   *  The check is caseinsensitiv!
   *  @method checkNamespace
   *  @param namespace { String }
   *  @param user { Object }
   */
  function checkNamespace( namespace, user ){
    if( !user.notify )
      throw new Error('USER HAS NO NAMESPACES' + user.toString() );
    var regexp = new RegExp( namespace, 'i');
    var isInside = user.notify.match(regexp);
    if( !( isInside instanceof Array ) )
      throw new Error('NAMESPACE IS NOT AVAILABLE' + user.toString());
  }

  return Notify;

};