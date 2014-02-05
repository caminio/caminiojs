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


  };

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
        self.model.create( req.body[self.underscoredName], function( err, doc ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          return res.json( doc );
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
   * @private
   */
  CrudModel.prototype.index = function createIndex(){    
    
    var self = this;

    if( !('index' in this.controller) )
      this.controller['index'] = function( req, res ){
        self.model.find( function( err, docs ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          return res.json( docs );
        });
      }

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

        var conditions = collectConditions( req );
        var options = {};

        var order = collectOrder( req );

        var q = self.model.find( conditions );

        if( _.keys(order).length > 0 )
          q.sort( order );

        q.exec( function( err, docs ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          return res.json( docs );
        });

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

        self.model.findOne( { _id: req.param('id') }, function( err, doc ){
          if( err ){ return res.json( 500, { error: 'server_error', details: err }); }
          return res.json( doc );
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
            return res.json( doc );
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
   * @method collectConditions
   * @private
   * @example
   *
   *     ?name=test
   *     ?name=regexp(/^tes/)&price=gt(5)
   *     ?camDomains=arr(domain1.com,domain2.com)
   *
   */
  function collectConditions( req ){
    var cond = {};
    if( 'id' in req.params ) 
      cond._id = req.param('id');
    if( req.query )
      _.each( req.query, function( val, key ){
        if( key === 'order' ) return;
        if( _.contains(val, 'regexp(') )
          val = getRegExp( val );
        else if( val.match(/^lt\(|^gt\(|^arr\(|^lte\(|^gte\(|^range\(/) )
          val = getOperatorQuery( val );
        cond[key] = val;
      });
    
    return cond;
  }

  function collectOrder( req ){
    var order = {};

    if( req.query && 'order' in req.query ){
      req.query.order.split(',').forEach( function( field ){
        if( _.contains( field, '.desc' ) )
          order[field.replace('.desc','')] = 'desc';
        else
          order[field.replace('.asc','')] = 'asc';
      });
    }
    return order;
  }

  function getRegExp( str, caseSensitive ){
    str = str.replace('regexp','');
    caseSensitive = caseSensitive || true;
    if( str.indexOf('/i') === str.length -2 )
      caseSensitive = true;
    str = str.replace('(/','').replace('/i)','').replace('/)','');
    return new RegExp(str, caseSensitive ? 'i' : '');
  }

  function getOperatorQuery( str ){
    str = str.replace(')','');
    var res = {};
    if( str.indexOf('lt(') === 0 )
      res.$lt = str;
    else if( str.indexOf('gt(') === 0 )
      res.$gt = str;
    return res;
  }

};