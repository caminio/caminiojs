/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var inflection    = require('inflection');

module.exports = function( caminio ){

  /**
   * @class CrudModel
   * @constructor
   *
   * @param {String} modelName
   * @param {String} controllerName
   * @param {String} route
   */
  function CrudModel( modelName, controllerName, route ){

    this.model = caminio.models[ modelName ];
    this.controller = caminio.controller.load( controllerName );
    this.underscoredName = inflection.underscore( modelName );
    this.route = route;
    this.controllerName = controllerName;
    this.modelName = modelName;

    this.index();
    this.create();
    this.update();
    this.show();
    this.destroy();


  }

  /**
   * 
   * creates a CREATE method for the controller
   * existing routes will remain untouched
   *
   * @method create
   * @private
   */
  CrudModel.prototype.create = function createCreate(){

    if( 'create' in this.controller )
      return;

    var self = this;

    this.controller['create'] = function( req, res ){
      if( !(self.underscoredName in req.body) )
        return res.json(400,{ error: 'missing_model_name_in_body', details: 'expected ' + self.underscoredName });
      self.model.create( req.body[self.underscoredName], function( err, doc ){
        if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
        return res.json( doc );
      });
    }

    caminio.controller.createRoute( 'post', this.route, this.controllerName, 'create' );

  } 

  /**
   * 
   * creates a INDEX method for the controller
   * existing routes will remain untouched
   *
   * @method index
   * @private
   */
  CrudModel.prototype.index = function createIndex(){

    if( 'index' in this.controller )
      return;

    var self = this;

    this.controller['index'] = function( req, res ){
      self.model.find( function( err, docs ){
        if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
        return res.json( docs );
      });
    }

    caminio.controller.createRoute( 'get', this.route, this.controllerName, 'index' );

  }

  /**
   * 
   * creates a SHOW method for the controller
   * existing routes will remain untouched
   *
   * @method show
   * @private
   */
  CrudModel.prototype.show = function createShow(){

    if( 'show' in this.controller )
      return;

    var self = this;

    this.controller['show'] = function( req, res ){
      
      if( !req.param('id') ){ return res.json(400, { error: 'invalid_request', details: 'missing id' }); }

      self.model.findOne({ _id: req.param('id') }, function( err, doc ){
        if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
        return res.json( doc );
      });
    }

    caminio.controller.createRoute( 'get', this.route+'/:id', this.controllerName, 'show' );

  }

  /**
   * 
   * creates an UPDATE (PUT) method for the controller
   * existing routes will remain untouched
   *
   * @method update
   * @private
   */
  CrudModel.prototype.update = function createUpdate(){

    if( 'update' in this.controller )
      return;

    var self = this;

    this.controller['update'] = function( req, res ){
      if( !(self.underscoredName in req.body) )
        return res.json(400,{ error: 'missing_model_name_in_body', details: 'expected ' + self.underscoredName });

      self.model.update( { _id: req.param('id') }, req.body[self.underscoredName], function( err, affected ){
        if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
        self.model.findOne( { _id: req.param('id') }, function( err, doc ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          return res.json( doc );
        });
      });
    }

    caminio.controller.createRoute( 'put', this.route+'/:id', this.controllerName, 'update' );

  } 

  /**
   * 
   * creates an DESTROY (DELETE) method for the controller
   * existing routes will remain untouched
   *
   * @method destroy
   * @private
   */
  CrudModel.prototype.destroy = function createDestroy(){

    if( 'destroy' in this.controller )
      return;

    var self = this;

    this.controller['destroy'] = function( req, res ){
      if( !(self.underscoredName in req.body) )
        return res.json(400,{ error: 'missing_model_name_in_body', details: 'expected ' + self.underscoredName });

      self.model.remove( { _id: req.param('id') }, function( err ){
        if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
        return res.json({});
      });
    }

    caminio.controller.createRoute( 'delete', this.route+'/:id', this.controllerName, 'destroy' );

  } 
  return CrudModel;

}