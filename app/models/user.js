/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var jsonSelect = require('mongoose-json-select')
  , MessageSchema = require('./schemas/message')
  , crypto = require('crypto')
  , orm = require('../../').orm;

/**
 * The user class is the main user object
 * for any operations in nginios
 *
 * @class User
 */

/**
 * computes the user's full name
 * to display
 * in worst case, this is the user's email
 * address
 *
 * @method getUserFullName
 * @private
 *
 **/
function getUserFullName(){
  if( this.name.first && this.name.last )
    return this.name.first + ' ' + this.name.last;
  else if( this.name.first )
    return this.name.first;
  else if( this.name.last )
    return this.name.last;
  else if( this.name.nick )
    return this.name.nick;
  else
    return this.email;
}

/**
 * validates, if email has at least @
 *
 * @method EmailValidator
 * @private
 *
 **/
var EmailValidator = function EmailValidator( val ){
  if( !val ) return false;
  return val.match(/@/);
}

/**
 *
 * @constructor
 *
 * @property name
 * @type Object
 *
 * @property name.first
 * @type String
 *
 * @property name.last
 * @type String
 *
 * @property email
 * @type String
 *
 **/
var UserSchema = orm.Schema({
      name: {
        first: String,
        last: String,
        nick: String
      },
      encrypted_password: {type: String, required: true},
      salt: {type: String, required: true},
      preferences: {
        locale: { type: String, default: 'en' },
        dashboard: {
          docklets: []
        }
      },
      messages: [ MessageSchema ],
      email: { type: String, 
               lowercase: true,
               required: true,
               index: { unique: true },
               validate: [EmailValidator, 'invalid email address'] },
      groups: [ { type: orm.Schema.Types.ObjectId, ref: 'Group' } ],
      domains: [ { type: orm.Schema.Types.ObjectId, ref: 'Domain' } ],
      confirmation: {
        key: String,
        expires: Date,
        last_success: Date,
        tries: { type: Number, default: 3 }
      },
      created: { 
        at: { type: Date, default: Date.now },
        by: { type: orm.Schema.Types.ObjectId, ref: 'User' }
      },
      updated: { 
        at: { type: Date, default: Date.now },
        by: { type: orm.Schema.Types.ObjectId, ref: 'User' }
      },
      locked: { 
        at: { type: Date },
        by: { type: orm.Schema.Types.ObjectId, ref: 'User' }
      },
      description: String,
      billing_information: {
        address: {
          street: String,
          zip: String,
          city: String,
          state: String,
          country: String,
          salutation: String,
          academicalTitle: String
        },
        email: { type: String, 
                 lowercase: true,
                 match: /@/ },
      },
      phone: {
        type: String,
        match: /^[\d]*$/
      }
});

/**
 * name.full virtual
 *
 * constructs a string which is definitely not null
 * and represents a (not unique) name of this user
 *
 * @method name.full
 * @return {String} full name of the user
 *
 * @example
 *
 *    user.name.full
 *    > Henry King
 *
 **/
UserSchema.virtual('name.full').get( getUserFullName ).set( function( name ){
  if( name.split(' ') ){
    this.name.first = name.split(' ')[0];
    this.name.last = name.split(' ')[1];
  } else
    this.name.first = name;
});

/**
 * show the number of unread messages
 *
 * @method unread_messages
 *
 **/
UserSchema.virtual('unread_messages').get( function(){
  var unread = 0;
  this.messages.forEach( function( message ){
    if( !message.read ) unread+=1;
  });
  return unread;
});;

/**
set password for this user

the password will be available for the rest of this 
instance's live-time. Only the encrytped version in 
property encrypted_password will be stored to the db

  @method password virtual set
  @param {String} password

  @example
    
      user.password('test');

**/
UserSchema.virtual('password').set(function( password ) {
    this._password = password;
    this.salt = this.generateSalt();
    this.encrypted_password = this.encryptPassword(password);
})

/**

  get unenrypted password

  @method password virtual get
  @return {String} the unencrypted password (exists only for the time of obejct
creation)
**/
UserSchema.virtual('password').get(function() { 
  return this._password; 
});

/**
authenticate user

compares encrytped password with given plain text password

  @method authenticate
  @param {String} plainTextPassword the plain text password which
will be hase-compared against the original password saved to
the database
**/
UserSchema.method('authenticate', function(plainTextPassword) {
  return this.encryptPassword(plainTextPassword) === this.encrypted_password;
});

/**
regenerateAuthToken

regenerates the auth_token object by generating a
new random hash and updating ip address of user

  @method regenerateAuthToken
  @param {String} ip address of user

**/
UserSchema.method('regenerateAuthToken', function(ipAddress) {
  this.auth_token.token = this.encryptPassword(ipAddress);
  this.auth_token.ip_address = ipAddress;
  this.auth_token.at = new Date();
});

/**
generate salt

generate the password salt

  @method generateSalt
  @private
**/
UserSchema.method('generateSalt', function() {
  return Math.round((new Date().valueOf() * Math.random())) + '';
});

/**

encrypt password

  @param {String} password - clear text password string
to be encrypted
**/
UserSchema.method('encryptPassword', function(password) {
  return crypto.createHmac('sha256WithRSAEncryption', this.salt).update(password).digest('hex');
});

/**

  @method isAdmin
  @param {Domain|Group|ObjectId|String} groupOrDomain [optional] domain or group object, ObjectId of group/domain object or string of group/domain object id
  @return {Boolean} if the user is admin
**/
UserSchema.method('isAdmin', function(groupOrDomain){
  return true;
});

UserSchema.virtual('id').get(function(){
  return this._id.toHexString();
});

UserSchema.set('toJSON', { virtuals: true });
UserSchema.plugin(jsonSelect, '-encrypted_password -salt -confirmation -auth_tokens');

module.exports = UserSchema;
