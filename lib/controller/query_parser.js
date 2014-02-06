/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var _ = require('lodash');

module.exports = function( caminio ){

  /**
   *  
   *  @class QueryParser
   *  @constructor
   *  @example
   *
   *      query = 123;
   */
  function QueryParser( model, reqQuery ){
    this.q = model.find();
    var self = this;
   
    if( reqQuery )
      _.each( reqQuery, function(val,key){
        self.q.where( self.collectConditions.call(self,val,key) );
      });

  }

  /** 
   *  @method exec
   *  @param cb callback
   */
  QueryParser.prototype.exec = function exec( cb ){
    this.q.exec( cb );
  };

  /** 
   *
   *  @method collectConditions
   *  @param val 
   *  @param key 
   */
  QueryParser.prototype.collectConditions = function collectConditions( val, key ){
    var self = this;
    var cond = {};
    if( key === 'order' ) return;
    if( _.contains(val, 'regexp(') )
      return self.getRegExp( val, key );
    else if(key === 'or'){
      cond.$or = val.map( function( item ){
        var param = Object.keys(item);
        return self.collectConditions.call( self, item[param], param );
      });
      return cond;
    }
    else if( typeof(val) === 'string' && val.match(/^lt\(|^in\(|^gt\(|^arr\(|^lte\(|^gte\(|^range\(/) )
      return this.getOperatorQuery( val, key );
    cond[key] = val;
    return cond;

  };

  /** 
   *  @method collectOrder
   *  @param req 
   */
  QueryParser.prototype.collectOrder = function collectOrder( req ){
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
  };

  /** 
   *  @method getRegExp
   *  @param str
   *  @param key
   */
  QueryParser.prototype.getRegExp = function getRegExp( str, key ){
    str = str.replace('regexp','');
    var caseInSensitive = str.indexOf('/i') > 0;
    str = str.replace('(/','').replace('/)','');
    var cond = {};
    cond[key] = new RegExp(str, caseInSensitive ? 'i' : '');
    return cond;
  };

  /** 
   *  @method getOperatorQuery
   *  @param str
   *  @param key
   */
  QueryParser.prototype.getOperatorQuery = function getOperatorQuery( str, key ){
    var orig = str;
    str = str.replace(')','');
    var arr = str.split('(');
    var cond = {};
    switch( arr[0] ){

      case 'lt':
        cond[key] = { $lt: parseFloat(arr[1]) };
        return  cond;
        
      case 'gt':
        this.q.where(key).gt( parseFloat(arr[1]) );
        break;

      case 'in':
        val = arr[1].split(',');
        cond[key] = { '$in': val };
        return cond;

      default:
        throw new Error('unknown_syntax:' + orig);

    }
  };

  return QueryParser;

};