/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var inflection = require('inflection');


/**
 * @class autorest
 *
 */
module.exports = function( caminio ){

  var CrudModel = require('./crud_model')(caminio);

  return {
    create: create
  };

  /**
   * creates CRUD methods for the given controller
   * Only controllers with a set up route will be
   * considered and passed-in here.
   *
   * @method create
   * @param {String} controllerName
   * @param {String} route
   *
   */
  function create( controllerName, route ){

    var modelName = controllerName.replace('Controller','');
    controllerName = inflection.pluralize(modelName)+'Controller';
    if( !(modelName in caminio.models) )
      throw Error('autorest failed. Missing model ' + modelName);

    var controller = caminio.controller.load( controllerName );

    if( !controller ){
      var controllerDef = function( caminio, policies, middleware ){ 
        return {
          _before: {
            //'*': policies.ensureLogin
          }
        };
      };
      caminio.controller.stack[controllerName] = controllerDef;
      controller = caminio.controller.load( controllerName );
    }

    
    var crudModel = new CrudModel( modelName, controllerName, route );

  }

};