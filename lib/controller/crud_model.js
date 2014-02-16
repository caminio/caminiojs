/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _             = require('lodash');
var inflection    = require('inflection');

module.exports = function( caminio ){

  var QueryParser   = require('./query_parser')(caminio);

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
    this.pluralizedUnderscoredName = inflection.pluralize(inflection.underscore( modelName ));

    this.index();
    this.find();
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

    var self = this;

    if( !('create' in this.controller) )
      this.controller['create'] = function( req, res ){
        if( !(self.underscoredName in req.body) )
          return res.json(400,{ error: 'missing_model_name_in_body', expected: 'expected ' + self.underscoredName, got: req.body });

        // require the new model to get the domain property set
        // if present in schema
        if( 'camDomain' in self.model.schema.paths ){
          if( !req.body[self.underscoredName].camDomain )
            req.body[self.underscoredName].camDomain = res.locals.currentDomain;
          if( !req.body[self.underscoredName].camDomain )
            return res.json(400, { error: 'domain_required' });
        }

        self.model.create( req.body[self.underscoredName], function( err, doc ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          var result = getModelWithNamespace( req.header('namespaced'), self.model.modelName, JSON.parse(JSON.stringify(doc)) );
          if( req.header('sideload') )
            result = transformJSON( result, req.header('namespaced') );
          return res.json( result );
        });
      }

    caminio.controller.createRoute( 'post', this.route, this.controllerName, 'create' );

  };

  /**
   * 
   * creates a INDEX method for the controller
   * existing routes will remain untouched
   *
   * @method index
   * @return {JSON} with all elements within currentDomain
   *
   * @private
   */
  CrudModel.prototype.index = function createIndex(){    
    
    var self = this;

    if( !('index' in this.controller) )
      this.controller['index'] = function( req, res ){
        var q = self.model.find();

        if( typeof(self.model.populateOnShow) !== 'undefined' )
          q.populate( self.model.populateOnShow );

        if( res.locals.currentDomain )
          q.where({ camDomain: res.locals.currentDomain.id });

        q.exec( function( err, docs ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          var result = getModelWithNamespace( req.header('namespaced'), self.model.modelName, JSON.parse(JSON.stringify(docs)), true );
          if( req.header('sideload') )
            result = transformJSON( result, req.header('namespaced') );
          return res.json( result );
        });
      };

    caminio.controller.createRoute( 'get', this.route, this.controllerName, 'index' );

  };

  /**
   * 
   * creates a FIND method for the controller
   * existing routes will remain untouched
   *
   * @method find
   * @private
   */
  CrudModel.prototype.find = function createFind(){

    var self = this;


    if( !('find' in this.controller) )
      this.controller['find'] = function( req, res ){
        var queryParser;
        try{
          var query = Object.keys( req.body ).length ? req.body : req.query;
          queryParser = new QueryParser( self.model, query );        
          queryParser.exec( function( err, docs ){
            if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
            var result = getModelWithNamespace( req.header('namespaced'), self.model.modelName, JSON.parse(JSON.stringify(docs)), true );
            if( req.header('sideload') )
              result = transformJSON( result, req.header('namespaced') );
            return res.json( result );
          });
        }catch( e ){
          caminio.logger.info( e.stack );
          return res.json( 400, { error: 'syntax_error', details: e.message });
        }
      };

    caminio.controller.createRoute( 'get', this.route+'/find', this.controllerName, 'find' );

  };

  /**
   * 
   * creates a SHOW method for the controller
   * existing routes will remain untouched
   *
   * @method show
   * @private
   */
  CrudModel.prototype.show = function createShow(){

    var self = this;

    if( !('show' in this.controller) )
      this.controller['show'] = function( req, res ){
        
        if( !req.param('id') ){ return res.json(400, { error: 'invalid_request', details: 'missing id' }); }

        var q = self.model.findOne( { _id: req.param('id') } );

        if( typeof(self.model.populateOnShow) !== 'undefined' )
          q.populate( self.model.populateOnShow );
        
        q.exec(function( err, doc ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          var result = getModelWithNamespace( req.header('namespaced'), self.model.modelName, JSON.parse(JSON.stringify(doc)) );
          if( req.header('sideload') )
            result = transformJSON( result, req.header('namespaced') );
          return res.json( result );
        });
      };

    caminio.controller.createRoute( 'get', this.route+'/:id', this.controllerName, 'show' );

  };

  /**
   * 
   * creates an UPDATE (PUT) method for the controller
   * existing routes will remain untouched
   *
   * @method update
   * @private
   */
  CrudModel.prototype.update = function createUpdate(){

    var self = this;

    if( !('update' in this.controller) )
      this.controller['update'] = function( req, res ){
        if( !(self.underscoredName in req.body) )
          return res.json(400,{ error: 'missing_model_name_in_body', details: 'expected ' + self.underscoredName });

        self.model.update( { _id: req.param('id') }, req.body[self.underscoredName], function( err, affected ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          self.model.findOne( { _id: req.param('id') }, function( err, doc ){
            if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
            var result = getModelWithNamespace( req.header('namespaced'), self.model.modelName, JSON.parse(JSON.stringify(docs)) );
            return res.json( result );
          });
        });
      };

    caminio.controller.createRoute( 'put', this.route+'/:id', this.controllerName, 'update' );

  };

  /**
   * 
   * creates an DESTROY (DELETE) method for the controller
   * existing routes will remain untouched
   *
   * @method destroy
   * @private
   */
  CrudModel.prototype.destroy = function createDestroy(){

    var self = this;

    if( !('destroy' in this.controller) )
      this.controller['destroy'] = function( req, res ){

        self.model.remove( { _id: req.param('id') }, function( err ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          return res.json({});
        });
      };

    caminio.controller.createRoute( 'delete', this.route+'/:id', this.controllerName, 'destroy' );

  };

  return CrudModel;

  /**
   * check if a modelNamespace has been configured
   * and fill it with the result. Otherwise just return
   * the result
   *
   * @method getModelWithNamespace
   * @private
   */
  function getModelWithNamespace( namespace, modelName, dbResult, plural ){
    if( !namespace )
      return dbResult;

    var result = {};
    if( namespace === 'true' ){
      if( plural )
        result[ inflection.pluralize(inflection.underscore(modelName)) ] = dbResult;
      else
        result[ inflection.underscore(modelName) ] = dbResult;
    } else
      result[ namespace ] = dbResult;

    return result;

  }

  /**
   * transform the resulted JSON into sideloaded model if option for this model
   * is set to schema.static('sideload', true);
   *
   * @method transformJSON
   * @private
   */
  function transformJSON( json, namespace ){
    var result = {};
    var objHome = result;
    var startAt;
    var startAtObj = json;
    if( namespace ){
      startAt = Object.keys(json)[0];
      startAtObj = json[startAt];
      objHome = result[startAt] = {};
    }
    if( startAtObj instanceof Array ){
      objHome = result[startAt] = [];
      for( var i in startAtObj ){
        obj = startAtObj[i];
        objHome.push( parseTransformJSONObj( obj, result ) );
      }
    } else{
      if( startAt )
        result[startAt] = parseTransformJSONObj( startAtObj, result );
      else
        result = parseTransformJSONObj( startAtObj, result );
    }
    return result;
  }

  function parseTransformJSONObj( obj, result ){
    var partialRes = {};
    for( var key in obj ){
      var val = obj[key];
      if( val instanceof Array && val.length > 0 && '_id' in val[0]){
        partialRes[key] = [];
        result[key] = result[key] || [];
        val.forEach( function(arrObj){
          result[key].push(arrObj);
          partialRes[key].push( arrObj._id );
        });
      } else{
        partialRes[key] = val;
      }
    }
    return partialRes;
  }

};
