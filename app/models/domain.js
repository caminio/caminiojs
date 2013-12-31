/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */
  
var MessageSchema = require('./schemas/message')
  , nginios = require('../../lib/nginios');

/**
 * validates, if domain name has at least
 * one dot and consists of at least 2 chars LHS and RHS
 */
var DomainNameValidator = function DomainNameValidator( val ){
  if( !val ) return false;
  return val.match(/^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[\.]{0,1}[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$/);
}

/**

  @class Domain
  @constructor

**/

var DomainSchema = nginios.orm.Schema({
    name: { type: String, 
            required: true,
            lowercase: true,
            required: true,
            index: { unique: true },
            validate: [ DomainNameValidator, 'invalid domain name' ] },
    users: [ { type: nginios.orm.Schema.Types.ObjectId, ref: 'User' } ],
    groups: [ { type: nginios.orm.Schema.Types.ObjectId, ref: 'Domain' } ],
    owner: { type: nginios.orm.Schema.Types.ObjectId, ref: 'User', required: true },
    messages: [ MessageSchema ],
    created: { 
      at: { type: Date, default: Date.now },
      by: { type: nginios.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    updated: { 
      at: { type: Date, default: Date.now },
      by: { type: nginios.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    locked: {
      at: { type: Date },
      by: { type: nginios.orm.Schema.Types.ObjectId, ref: 'User' }
    },
    description: String,
});

/**
locks a domain. This affects any user associated with this domain.

Sets. locked.at, locked.by

@method lock
@class Domain
@param {User} user The user object which locks the domain (must be admin)
**/
DomainSchema.method('lock', function(user){
  if( !user.isAdmin(this) )
    throw 'insufficient rights';
  this.locked.at = new Date();
  this.locked.by = user;
});

/**

  Adds a user to this domain

  @class Domain
  @method addUser
  @param {User} user the user to be added
  @param {User} manager a user with owner status (only domain managers can add users)
  @param {Object} options
  @param {Boolean} options.can_manage
**/
DomainSchema.method('addUser', function(user,manager,options){
  if( !manager.isAdmin(this) )
    throw 'insufficient rights';
  options = options || {};
  user.domains.push({
    can_manage: options.can_manage,
    domain: this,
    created: { by: manager },
    updated: { by: manager }
  });
});

module.exports = DomainSchema;
