/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

  
var MessageSchema = require('./schemas/message')
  , mongoose = require('mongoose');

var GroupSchema = mongoose.Schema({
    name: { type: String, required: true },
    users: [ { type: mongoose.Schema.Types.ObjectId, ref: 'User' } ],
    messages: [ MessageSchema ],
    domains: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Domain' } ],
    created: { 
      at: { type: Date, default: Date.now },
      by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
    },
    updated: { 
      at: { type: Date, default: Date.now },
      by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
    },
    description: String,
});

module.exports = mongoose.model('Group', GroupSchema);
