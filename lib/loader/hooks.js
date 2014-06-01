module.exports = function( caminio ){

  'use strict';

  var async           = require('async');
  var inflection      = require('inflection');

  caminio.hooks       = {};
  caminio.hooks._data = {};

  /**
   * @method invokeHook
   * @param {String} name of the hook
   * @param {Object} options
   * @param {Object} options.scope the scope (this-object) for the hooks
   * @param {Function} callback
   */
  caminio.hooks.invoke = function invokeHook( name, options, cb ){
 
    if( typeof(options) === 'function' ){
      cb = options;
      options = {};
    }
    options = options || {};

    if( caminio.hooks._data[ name ] )
      return async.eachSeries( caminio.hooks._data[ name ], function( hook, nextIteration ){
        hook.call( options.scope || null, nextIteration );
      }, cb || null );

    if( cb )
      cb();

  };

  /**
   * @method registerHook
   * @param {String} name of the hook
   * @param {Function} function to be called
   */
  caminio.hooks.register = function registerHook( name, hook ){
    name = inflection.dasherize( name.replace('.js','') );
    caminio.hooks._data[ name ] = caminio.hooks._data[ name ] || [];
    caminio.hooks._data[ name ].push( hook );
  };

};

// DEPRECATED since 1.1
//
///*
// * camin.io
// *
// * @author quaqua <quaqua@tastenwerk.com>
// * @date 01/2014
// * @copyright TASTENWERK http://tastenwerk.com
// * @license MIT
// *
// */
//
//var _             = require('lodash')
//  , async         = require('async');
//
//
//module.exports = function( caminio ){
//
//  var hooks = {
//    before: {},
//    after: {}
//  }
//
//  return {
//    define: defineHook,
//    invoke: invokeHook
//  }
//
//  /**
//   * hook something inbetween an initializiation process.
//   * The hook will be invoked, either before or after the
//   * defined method.
//   *
//   * @class  Caminio
//   * @method define
//   *
//   * @param {String} type ['before','after']
//   * @param {String} initialiser an initializer name. Possible
//   * values: ['session']
//   * @param {Function} fn the function to be executed
//   *
//   * @example:
//   *
//   *     new Hook( 'before', 'session' )
//   *     => will be invoked before session is invoked
//   *
//   */
//  function defineHook( type, initializer, name, fn ){
//    hooks[type][initializer] = hooks[type][initializer] || [];
//    hooks[type][initializer].push( { name: name, fn: fn } );
//  }
//
//  /**
//   * invoke hooks for given type and initializer
//   *
//   * @class Caminio
//   * @method invoke
//   *
//   * @param {String} type ['before', 'after']
//   * @param {String} initializer
//   * @param {Function} cb
//   *
//   */
//  function invokeHook( type, initializer, cb ){
//    if( !hooks[type][initializer] || hooks[type][initializer].length < 1 )
//      return (typeof(cb) === 'function' ? cb() : null);
//
//    async.each( hooks[type][initializer], function( runner, cbAsync ){
//      caminio.logger.debug('invoking hook', runner.name, 'in:', type, initializer);
//      runner.fn( cbAsync );
//    }, cb );
//
//  }
//
//}
