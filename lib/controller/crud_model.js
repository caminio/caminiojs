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
  var util          = require('../../util');

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

        if( 'createdBy' in self.model.schema.paths && res.locals.currentUser ){
          if( !req.body[self.underscoredName].createdBy )
            req.body[self.underscoredName].createdBy = res.locals.currentUser;
        }

        if( 'updatedBy' in self.model.schema.paths && res.locals.currentUser ){
          if( !req.body[self.underscoredName].updatedBy )
            req.body[self.underscoredName].updatedBy = res.locals.currentUser;
        }

        if( 'createdAt' in self.model.schema.paths )
          req.body[self.underscoredName].createdAt = new Date();

        if( 'updatedAt' in self.model.schema.paths )
          req.body[self.underscoredName].updatedAt = new Date();

        self.model.create( req.body[self.underscoredName], function( err, doc ){

          if( err ){ 
            if( err.name && err.name === 'ValidationError' )
              return res.json( 422, util.formatErrors(err) );
            return res.json( 500, { error: 'server_error', details: err }); 
          }

          var q = self.model.findOne( { _id: doc._id } );

          if( typeof(self.model.populateOnShow) !== 'undefined' )
            q.populate( self.model.populateOnShow );
          
          q.exec(function( err, doc ){
            if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
            var result = getModelWithNamespace( req.header('namespaced'), self.model.modelName, JSON.parse(JSON.stringify(doc)) );
            if( req.header('sideload') )
              result = util.transformJSON( result, req.header('namespaced') );
            return res.json( result );
          });
        });
      };

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
        
        var query = Object.keys( req.body ).length ? req.body : req.query;
        var q = new QueryParser( self.model, query );

        if( typeof(self.model.populateOnShow) !== 'undefined' )
          q.q.populate( self.model.populateOnShow );

        if( res.locals.currentDomain && 'camDomain' in self.model.schema.paths )
          q.q.where({ camDomain: res.locals.currentDomain.id });

        var limit,
            offset = 0;

        if( req.param('limit') && typeof(parseInt(req.param('limit'))) === 'number' )
          limit = parseInt(req.param('limit') );
        if( req.param('offset') && typeof(parseInt(req.param('offset'))) === 'number' )
          offset = req.param('offset');
        if( limit )
          q.q.limit(limit).skip(offset*limit);

        q.exec( function( err, docs ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          var result = getModelWithNamespace( req.header('namespaced'), self.model.modelName, JSON.parse(JSON.stringify(docs)), true );

          if( req.header('sideload') )
            result = util.transformJSON( result, req.header('namespaced') );

          if( typeof(self.model.rebuildJSON) === 'function' )
            return res.json( self.model.rebuildJSON( result ) );

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
              result = util.transformJSON( result, req.header('namespaced') );
            return res.json( result );
          });
        } catch( e ){
          caminio.logger.error( e.stack );
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

          if( typeof(self.model.rebuildJSON) === 'function' )
            return res.json( self.model.rebuildJSON( doc ) );

          var result = getModelWithNamespace( req.header('namespaced'), self.model.modelName, JSON.parse(JSON.stringify(doc)) );
          if( req.header('sideload') )
            result = util.transformJSON( result, req.header('namespaced') );
          if( result )
            return res.json( result );
          return res.json( 404, { error: 'not_found' } );
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
      this.controller['update'] = [ getDoc, updateDoc, getDoc, function( req, res ){

        if( typeof(self.model.rebuildJSON) === 'function' )
          return res.json( self.model.rebuildJSON( req.doc ) );
        
          var result = getModelWithNamespace( req.header('namespaced'), 
                                              self.model.modelName, 
                                              JSON.parse(JSON.stringify( req[self.underscoredName] )) );
          if( req.header('sideload') )
            result = util.transformJSON( result, req.header('namespaced') );
          return res.json( result );
        }];

    caminio.controller.createRoute( 'put', this.route+'/:id', this.controllerName, 'update' );

    /**
     * update a document
     * @method updateDoc
     * @param {Object} req
     * @param {Object} res
     * @param {Function} callback
     *
     */
    function updateDoc( req, res, next ){
      if( !(self.underscoredName in req.body) )
        return res.json(400,{ error: 'missing_model_name_in_body', details: 'expected ' + self.underscoredName });

      if( 'updatedBy' in self.model.schema.paths && res.locals.currentUser ){
        if( !req.body[self.underscoredName].updatedBy )
          req.body[self.underscoredName].updatedBy = res.locals.currentUser;
      }

      if( 'updatedAt' in self.model.schema.paths )
        req.body[self.underscoredName].updatedAt = new Date();

      req.doc.multiSet(req.body[self.underscoredName], req.doc.publicAttributes);

      req.doc.save( function( err, affected ){
        if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
        next();
      });
    };

    function getDoc( req, res, next ){
      var q = self.model.findOne( { _id: req.param('id') } );

      if( typeof(self.model.populateOnShow) !== 'undefined' )
        q.populate( self.model.populateOnShow );

      q.exec( function( err, doc ){

        if( err ){ 
          if( err.name && err.name === 'ValidationError' )
            return res.json( 422, util.formatErrors(err) );
          return res.json( 500, { error: 'server_error', details: err }); 
        }
        
        req[self.underscoredName] = req.doc = res.locals.doc = res.locals[self.underscoredName] = doc;
        next();

      });
    };

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
      this.controller['destroy'] = [ getDoc, function( req, res ){

        if( 'deletedBy' in req.doc )
          req.doc.deletedBy = res.locals.currentUser;

        req.doc.remove( function( err ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          return res.json({});
        });

      }];

    caminio.controller.createRoute( 'delete', this.route+'/:id', this.controllerName, 'destroy' );

    function getDoc( req, res, next ){
      var q = self.model.findOne( { _id: req.param('id') } );

      q.exec( function( err, doc ){

        if( err )
          return res.json( 500, { error: 'server_error', details: err }); 
        
        if( !doc )
          return res.json(404, { error: 'not found', id: req.param('id') });

        req[self.underscoredName] = req.doc = res.locals.doc = res.locals[self.underscoredName] = doc;
        next();

      });
    };

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

};
