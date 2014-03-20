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
   *      /find?name=123
   *
   *  Regular Expressions
   *
   *      /find?name=regexp(/Joh/)
   *
   *  less than
   *
   *      /find?amount=lt(100)
   *
   *  expects string to be in array given
   *
   *      /find?name=in(test,rama)
   *
   *  It is highly recommended to use an advanced query builder ( like jquery ) to
   *  produce more complex queries like:
   *
   *      $.getJSON('.../find', [
              { name: 'test' },
              { name: 'regexp(/ram/)'},
              { amount: 134},
              { amount: 3}
              ], function( responseJSON ){}
   *
   */
  function QueryParser( model, reqQuery ){
    this.q = model.find();
    var self = this;
   
    if( reqQuery ){
      var order;
      _.each( reqQuery, function(val,key){
        self.q.where( self.collectConditions.call(self,val,key) );
        if( val === 'order' )
          order = key;
      });
      self.q.sort( self.collectOrder.call(self,order) );
    }

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
    else if( typeof(val) === 'string' && val.match(/^ne\(|^lt\(|^in\(|^gt\(|^lte\(|^gte\(/) )
      return this.getOperatorQuery( val, key );
    else if( typeof(val) === 'string' && val.match(/true|false/) )
      val = (val === 'true');
    else if( typeof(val) === 'string' && val === 'null' )
      val = null;
    cond[key] = val;
    return cond;

  };

  /** 
   *  @method collectOrder
   */
  QueryParser.prototype.collectOrder = function collectOrder( order ){

    var result = {};

    if( order )
      order.split(',').forEach( function( field ){
        if( field.split(':').length !== 2 )
          return;
        var key = field.split(':')[0];
        result[key] = field.split(':')[1];
      });
    else
      result['name'] = 'asc';

    return result;
  };

  /** 
   *  @method getRegExp
   *  @param str
   *  @param key
   */
  QueryParser.prototype.getRegExp = function getRegExp( str, key ){
    str = str.replace('regexp','');
    var caseInSensitive = str.indexOf('/i') > 0;
    str = str.replace('(/','').replace('/i)','').replace('/)','');
    var cond = {};
    cond[key] = new RegExp(str, caseInSensitive ? 'i' : '');
    return cond;
  };

  /** 
   *  Identifies the following operators and 
   *  builds the mongo commands of it:
   *    lt - lower than, gt - greater than,
   *    lte - lower than equal, gte - greater than equal,
   *    in - values are in key value
   *  
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
      
      case 'ne':
        cond[key] = { $ne: ( arr[1] === 'null' ? null : arr[1] ) };
        return  cond;
        
      case 'lt':
        cond[key] = { $lt: parseFloat(arr[1]) };
        return  cond;
        
      case 'gt':
        cond[key] = { $gt: parseFloat(arr[1]) };
        return cond;

      case 'lte':
        cond[key] = { $lte: parseFloat(arr[1]) };
        return cond;

      case 'gte':
        cond[key] = { $gte: parseFloat(arr[1]) };
        return cond;

      case 'in':
        val = arr[1].split(',');
        cond[key] = { $in: val };
        return cond;

      default:
        throw new Error('unknown_syntax:' + orig);

    }
  };

  return QueryParser;

};