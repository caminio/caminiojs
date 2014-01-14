/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var jsonSelect = require('mongoose-json-select')
  , MessageSchema = require('./schemas/message')
  , crypto = require('crypto')
  , caminio = require('../../')
  , orm = caminio.orm;

/**
 * The user class is the main user object
 * for any operations in caminio
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
      preferences: { type: orm.Schema.Types.Mixed },
      messages: [ MessageSchema ],
      lang: { type: String, default: 'en' },
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
      role: { type: Number, default: 100 },
      last_login: {
        at: Date,
        ip: String
      },
      last_request_at: Date,
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

Reads domain, superuser attribute or role number
If role number is less than equal 5, user is admin

  @method isAdmin
  @param {Domain|Group|ObjectId|String} groupOrDomain [optional] domain or group object, ObjectId of group/domain object or string of group/domain object id
  @return {Boolean} if the user is admin
**/
UserSchema.method('isAdmin', function(groupOrDomain){
  if( this.isSuperUser() )
    return true;
  if( groupOrDomain instanceof orm.models.Domain )
    return groupOrDomain.owner.equals( this._id.toString() );
  return this.role <= 5;
});

UserSchema.virtual('admin').get(function(){
  if( this.isSuperUser() )
    return true;
  return this.role <= 5;
});

UserSchema.virtual('superuser').get(function(){
  return this.isSuperUser();
});

/**

  Return, if this user is a superuser.

  This method looks up in the app.config object for a superusers key. The email address of this user
  must be an array item of this key.

  @method isSuperUser
  @return {Boolean} if the user is superuser

  @example

    // ${APP_HOME}/config/environments/production.js
    ...
    config.superusers = [ 'admin@example.com' ];
    ...

**/
UserSchema.method('isSuperUser', function(){
  return caminio.app.config.superusers.indexOf(this.email) >= 0;
});

UserSchema.virtual('id').get(function(){
  return this._id ? this._id.toHexString() : null;
});

UserSchema.set('toJSON', { virtuals: true });
UserSchema.plugin(jsonSelect, '-encrypted_password -salt -confirmation -auth_tokens -_id -__v');

module.exports = UserSchema;
