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
  , inflection    = require('inflection')
  , async         = require('async')
  , mongoose      = require('mongoose');


module.exports = function( caminio ){

  return {
    init: init
  };

  function init( stack, cb ){

    for( var name in stack ){
      var schemaDef = stack[name];

      console.log('stack here');
      console.log('adding', name);
      var schema = schemaDef( caminio, mongoose );
      var Model = mongoose.model( name, schema, inflection.tableize(name) );
      caminio.models[name] = Model;

    }

    cb();

  }

  function loadAdapters(){

    var adapter = {};

    _.each( caminio.config.adapters, function( adapterInfo, name ){
      adapter[name] = require( process.cwd() + '/node_modules/' + name );
      adapter[name].config = adapterInfo;
    });

    return adapter;

  }

}