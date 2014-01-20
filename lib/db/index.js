/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var mongoose    = require('mongoose');


module.exports = function( caminio ){  

  return {
    connect: connectDB
  }

  function connectDB( cb ){

    var connStr = caminio.config.db.url;
    mongoose.connect(connStr);

    mongoose.connection
    .on('error', function( err ){
      caminio.logger.error( 'connection to '+connStr+' failed' );
      caminio.logger.error( err.toString() );
      if( typeof( cb ) === 'function' )
        callback();
    }).once('open', function(){
      caminio.logger.info('connection to '+connStr+' established');
      if( typeof( cb ) === 'function' )
        cb();
    });

  }

}