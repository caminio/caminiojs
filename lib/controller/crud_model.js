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

        var q = self.model.find();
        try{
          q = collectConditions( req, q );
        }catch(e){
          return res.json( 400, { error: 'syntax_error', details: e.message });  
        }
        var options = {};

//        q.sort(collectOrder( req ));


        //if( _.keys(order).length > 0 )
          //q.sort( order );

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
  function collectConditions( req, q ){
    if( 'id' in req.params ) 
      q.where( { _id: req.params.id } );
    if( req.query )
      _.each( req.query, function( val, key ){
        if( key === 'order' ) return;
        if( _.contains(val, 'regexp(') )
          val = getRegExp( val, q, key );
        else if( val.split('||').length > 1){

          val = val.split('||').map( collectConditions ); 
        }
        else if( val.match(/^lt\(|^gt\(|^arr\(|^lte\(|^gte\(|^range\(/) )
          q = getOperatorQuery( val, q, key );
        else
          throw new Error( 'syntax failure, should be gt(500), was ' + val);
      });
    return q;
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

  function getRegExp( str, q, key ){
    str = str.replace('regexp','');
    var caseInSensitive = str.indexOf('/i') > 0;
    str = str.replace('(/','').replace('/)','');
    var cond = {};
    cond[key] = new RegExp(str, caseInSensitive ? 'i' : '');
    q.where( cond );
  }

  function getOperatorQuery( str, q, key ){
    // lt(5)
    // { $lt: 5 }
    var orig = str;
    str = str.replace(')','');
    var arr = str.split('(');
    switch( arr[0] ){

      case 'lt':
        console.log("da", arr); 
        return q.where(key).lt( parseFloat(arr[1]) );
        
      case 'gt':
        q.where(key).gt( parseFloat(arr[1]) );
        break;

      default:
        throw new Error('syntax failure, should be gt(500), was ' + orig);

    }
  }

};