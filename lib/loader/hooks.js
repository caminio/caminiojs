/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _             = require('lodash')
  , async         = require('async');


module.exports = function( caminio ){

  var hooks = {
    before: {},
    after: {}
  }

  return {
    define: defineHook,
    invoke: invokeHook
  }

  /**
   * hook something inbetween an initializiation process.
   * The hook will be invoked, either before or after the
   * defined method.
   *
   * @class  Caminio
   * @method define
   *
   * @param {String} type ['before','after']
   * @param {String} initialiser an initializer name. Possible
   * values: ['session']
   * @param {Function} fn the function to be executed
   *
   * @example:
   *
   *     new Hook( 'before', 'session' )
   *     => will be invoked before session is invoked
   *
   */
  function defineHook( type, initializer, name, fn ){
    hooks[type][initializer] = hooks[type][initializer] || [];
    hooks[type][initializer].push( { name: name, fn: fn } );
  }

  /**
   * invoke hooks for given type and initializer
   *
   * @class Caminio
   * @method invoke
   *
   * @param {String} type ['before', 'after']
   * @param {String} initializer
   * @param {Function} cb
   *
   */
  function invokeHook( type, initializer, cb ){
    if( !hooks[type][initializer] || hooks[type][initializer].length < 1 )
      return (typeof(cb) === 'function' ? cb() : null);

    async.each( hooks[type][initializer], function( runner, cbAsync ){
      caminio.logger.debug('invoking hook', runner.name, 'in:', type, initializer);
      runner.fn( cbAsync );
    }, cb );

  }

}