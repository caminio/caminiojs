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
  , Waterline     = require('waterline');


module.exports = function( caminio ){

  return {
    init: init
  };

  function init( stack, cb ){

    async.each( stack, function( modelInfo, next ){

      var modelDef = require( modelInfo.path );
      modelDef.adapter = caminio.config.adapters['default'];

      var adapters     = loadAdapters()
        , tableName    = modelDef.tableName = ( modelDef.tableName || inflection.tableize(modelInfo.name) );

      if( '_config' in modelDef ){
        if( 'adapter' in modelDef._config )
          modelDef.adapter = modelDef._config.adapter;
      }

      var Model = Waterline.Collection.extend( _.omit(modelDef, '_config') );

      new Model({
        adapters: adapters,
        tableName: tableName
      }, function( err, collection ) {
        if (err) return next(err);
        caminio.models[modelInfo.name] = collection;
        return next();
      });


    }, cb );

  }

  function loadAdapters(){

    var adapter = {};

    _.each( caminio.config.adapters, function( adapterInfo, name ){
      if( !adapterInfo.module )
        return;
      adapter[name] = require( process.cwd() + '/node_modules/' + adapterInfo.module );
      adapter[name].config = adapterInfo;
    });

    return adapter;

  }

}