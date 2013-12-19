/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

  
var jsonSelect = require('mongoose-json-select')
  , MessageSchema = require('./schemas/message')
  , nginuous = require('../../lib/nginuous');

var GroupSchema = nginuous.orm.Schema({
    name: { type: String, required: true },
    users: [ { type: nginuous.orm.Schema.Types.ObjectId, ref: 'User' } ],
    messages: [ MessageSchema ],
    domains: [{ type: nginuous.orm.Schema.Types.ObjectId, ref: 'Domain' } ],
    created: { 
      at: { type: Date, default: Date.now },
      by: { type: nginuous.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    updated: { 
      at: { type: Date, default: Date.now },
      by: { type: nginuous.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    description: String,
});

module.exports = GroupSchema;
