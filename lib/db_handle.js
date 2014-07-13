/* jshint node: true */
/* jshint expr: true */
'use strict';

module.exports = exports = {

  dbHandle: function dbHandle( handle ){
    handle.init( this );
    this.db = handle;
    return this;
  }

};
