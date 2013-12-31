/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

  
var jsonSelect = require('mongoose-json-select')
  , MessageSchema = require('./schemas/message')
  , nginios = require('../../lib/nginios');

var GroupSchema = nginios.orm.Schema({
    name: { type: String, required: true },
    users: [ { type: nginios.orm.Schema.Types.ObjectId, ref: 'User' } ],
    messages: [ MessageSchema ],
    domains: [{ type: nginios.orm.Schema.Types.ObjectId, ref: 'Domain' } ],
    created: { 
      at: { type: Date, default: Date.now },
      by: { type: nginios.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    updated: { 
      at: { type: Date, default: Date.now },
      by: { type: nginios.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    description: String,
});

module.exports = GroupSchema;
