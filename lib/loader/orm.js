/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */


module.exports = function( caminio ){

  'use strict';

  var _             = require('lodash');
  var inflection    = require('inflection');
  var async         = require('async');
  var mongoose      = require('mongoose');
  var jsonSelect    = require('mongoose-json-select');
  var multiSet      = require('mongoose-multi-set');
  var mongoTrash    = require('../db/trash')(caminio);

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
      if( !schema ){
        caminio.logger.info('interpreting', name, 'to be an extension only');
        continue;
      }
        //throw Error('forgot to return schema in model '+name+'?');
      caminio.logger.info('registering model', name);

      if( schema.trash ){
        mongoTrash.setupTrash( name, schema );
        schema.static('restore', mongoTrash.restore);
      }

      schema.pre( 'init', applyBeforeInitModelHooks );

      var Model = mongoose.model( name, setupDefaults( schema ), inflection.tableize(name) );
      caminio.models[name] = Model;


    }

    cb();

  }
  
  function applyBeforeInitModelHooks( next ){
    caminio.hooks.invoke('before-init-model', { scope: this }, next);
  }

  //function loadAdapters(){

  //  var adapter = {};

  //  _.each( caminio.config.adapters, function( adapterInfo, name ){
  //    adapter[name] = require( process.cwd() + '/node_modules/' + name );
  //    adapter[name].config = adapterInfo;
  //  });

  //  return adapter;

  //}

  function setupDefaults( schema ){

    //schema.virtual('id').get(function(){ return this._id ? this._id.toHexString() : null; });
    schema.set('toJSON', { virtuals: true });
    schema.set('toObject', { virtuals: true });
    schema.publicAttributes = collectPublicAttrs(schema);
    schema.virtual('publicAttributes').get( function(){ return schema.publicAttributes; });
    _.each( schema.paths, function( val, key ){
      if( val.options && val.options.public ){
        if( schema.publicAttributes.indexOf(key) < 0 )
          schema.publicAttributes.push( key );
      }
    });
    // TODO: add public: true/false in schema and allow to
    // set all attributes as publicAttributes
    schema.plugin(jsonSelect, schema.publicAttributes.join(' '));
    schema.plugin(multiSet);

    return schema;

  }

  function collectPublicAttrs(schema){
    var attrs = schema.publicAttributes || ['_id'];
    if( attrs.indexOf('_id') < 0 )
      attrs.push('_id');
    if( attrs.indexOf('-__v') < 0 )
      attrs.push('-__v');
    Object.keys(schema.paths).forEach(function(key){
      if( schema.paths[key].public && attrs.indexOf(key) )
        attrs.push( key );
    });
    return attrs;
  }

};
