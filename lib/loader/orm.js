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
  , mongoose      = require('mongoose')
  , jsonSelect    = require('mongoose-json-select');


module.exports = function( caminio ){

  return {
    init: init
  };

  function init( stack, cb ){

    for( var name in stack ){

      var schemaDef = stack[name];
      if( typeof(schemaDef) !== 'function' ){
        caminio.logger.warn('ignored model',name,' as it does not have a valid model definition');
        continue;
      }

      var schema = schemaDef( caminio, mongoose );
      if( !schema )
        throw Error('forgot to return schema in model '+name+'?');

      var Model = mongoose.model( name, setupDefaults( schema ), inflection.tableize(name) );
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

  function setupDefaults( schema ){

    schema.post('save', function(next){ caminio.logger.debug('saved:', this); });
    //schema.virtual('id').get(function(){ return this._id ? this._id.toHexString() : null; });
    schema.set('toJSON', { virtuals: true });
    schema.publicAttributes = schema.publicAttributes || ['_id', 'name'];
    //schema.publicAttributes.push('id');
    schema.publicAttributes.push('_id');
    schema.publicAttributes.push('-__v');
    schema.plugin(jsonSelect, schema.publicAttributes.join(' '));

    return schema;

  }

}