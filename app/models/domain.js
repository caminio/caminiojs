/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */
  
var MessageSchema = require('./schemas/message')
  , nginious = require('../../lib/nginious');

/**
 * validates, if domain name has at least
 * one dot and consists of at least 2 chars LHS and RHS
 */
var DomainNameValidator = function DomainNameValidator( val ){
  if( !val ) return false;
  return val.match(/^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[\.]{0,1}[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$/);
}

var DomainSchema = nginious.orm.Schema({
    name: { type: String, 
            required: true,
            lowercase: true,
            required: true,
            index: { unique: true },
            validate: [ DomainNameValidator, 'invalid domain name' ] },
    users: [ { type: nginious.orm.Schema.Types.ObjectId, ref: 'User' } ],
    groups: [ { type: nginious.orm.Schema.Types.ObjectId, ref: 'Domain' } ],
    owner: { type: nginious.orm.Schema.Types.ObjectId, ref: 'User' },
    messages: [ MessageSchema ],
    created: { 
      at: { type: Date, default: Date.now },
      by: { type: nginious.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    updated: { 
      at: { type: Date, default: Date.now },
      by: { type: nginious.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    description: String,
});

module.exports = DomainSchema;
