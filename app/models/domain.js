/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */
  
var MessageSchema = require('./schemas/message')
  , nginuous = require('../../lib/nginuous');

/**
 * validates, if domain name has at least
 * one dot and consists of at least 2 chars LHS and RHS
 */
var DomainNameValidator = function DomainNameValidator( val ){
  if( !val ) return false;
  return val.match(/^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[\.]{0,1}[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$/);
}

var DomainSchema = nginuous.orm.Schema({
    name: { type: String, 
            required: true,
            lowercase: true,
            required: true,
            index: { unique: true },
            validate: [ DomainNameValidator, 'invalid domain name' ] },
    users: [ { type: nginuous.orm.Schema.Types.ObjectId, ref: 'User' } ],
    groups: [ { type: nginuous.orm.Schema.Types.ObjectId, ref: 'Domain' } ],
    owner: { type: nginuous.orm.Schema.Types.ObjectId, ref: 'User' },
    messages: [ MessageSchema ],
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

module.exports = nginuous.orm.model('Domain', DomainSchema);
