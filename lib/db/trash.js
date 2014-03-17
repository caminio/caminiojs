/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 04/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var mongoose      = require('mongoose'),
    inflection    = require('inflection');

module.exports = function( caminio ){  

  return {
    setupTrash: setupTrash,
    trash: trash
  };


  function setupTrash( name, schema ){

    schema.add({ deletedAt: { type: Date, default: Date.now }, deletedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }});

    var TrashModel = mongoose.model( name+'Trash', schema, inflection.tableize(name)+'_trash' );

    schema.pre('remove', trash);

  }

  function trash( next ){

    var Model = mongoose.models[ this.constructor.modelName + 'Trash' ];

    if( !Model ){
      var errMsg = 'No trash model has been set up for ' + this.constructor.modelName;
      caminio.logger.error( errMsg );
      return next( errMsg );
    }

    Model.create( this.toObject(), function( err ){
      if( err ){
        caminio.logger.error('error saving trash model instance', err);
        return next( err );
      }
      next();
    });
    

  }

};