/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */
  
var MessageSchema = require('./schemas/message')
  , jsonSelect = require('mongoose-json-select')
  , nginios = require('../../lib/nginios');

/**
 * Everything needs to be inside a domain, if nginios is operated
 * in multi-tenancy mode.
 *
 * @class Domain
 **/

/**
 * validates, if domain name has at least
 * one dot and consists of at least 2 chars LHS and RHS
 *
 * @method DomainNameValidator
 * @private
 *
 **/
var DomainNameValidator = function DomainNameValidator( val ){
  if( !val ) return false;
  return val.match(/^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[\.]{0,1}[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$/);
}

/**
 * @constructor
 *
 * @property name
 * @type String
 *
 * @property users
 * @type Array
 *
 * @property groups
 * @type Array
 *
 * List of applications this domain can access
 * @property granted_apps
 * @type Array
 *
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
    owner: { type: nginios.orm.Schema.Types.ObjectId, ref: 'User' },
    plan: { type: String, default: 'default' },
    preferences: { type: nginios.orm.Schema.Types.Mixed },
    allowed_gears: { type: Array, default: ['nginios'] },
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
 * locks a domain. This affects any user associated with this domain.
 * Sets. locked.at, locked.by
 * @method lock
 * @param {User} user The user object which locks the domain (must be admin)
**/
DomainSchema.method('lock', function(user){
  if( !user.isAdmin(this) )
    throw 'insufficient rights';
  this.locked.at = new Date();
  this.locked.by = user;
});

/**

  Adds a user to this domain. The user has to be saved seperately

  @method addUser
  @param {User} user the user to be added
  @param {User} manager a user with owner status (only domain managers can add users)
  @param {Function} callback
  @param {Object} err The error object, if anything goes wrong saving the domain
**/
DomainSchema.method('addUser', function( user, manager, callback ){
  if( manager && manager.id !== this.owner )
    throw 'insufficient rights';
  user.domains.push( this );
  this.users.push( user );
  this.save( callback );
});

DomainSchema.virtual('id').get(function(){
  return this._id ? this._id.toHexString() : null;
});

DomainSchema.set('toJSON', { virtuals: true });
DomainSchema.plugin(jsonSelect, '-_id -__v');

module.exports = DomainSchema;
