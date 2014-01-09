/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var mongoose = require('mongoose');

var DefaultPlugin = function DefaultPlugin( schema, options ){

  schema.add({ 
    name: { type: String, required: true, index: true },
    pos: { type: Number },
    created: { 
      at: { type: Date, default: Date.now },
      by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
    },
    updated: { 
      at: { type: Date, default: Date.now },
      by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
    }
  });

}

module.exports = exports = DefaultPlugin;
