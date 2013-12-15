/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */


var jsonSelect = require('mongoose-json-select')
  , db = require( __dirname + '/../../lib/db' )
  , crypto = require('crypto');

/**
 * UserLoginLogSchema
 *
 * the login log keeps track of
 * the users logins
 */
var UserLoginLogSchema = new db.Schema({
  ip: String,
  createdAt: { type: Date, default: Date.now }
});

/**
 * UserMessagesSchema
 *
 * a message is for inner communication
 * between users
 */
var UserMessagesSchema = new db.Schema({
  content: String,
  read: {type: Boolean, default: false},
  author: { type: db.Schema.Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now }
});

/**
 * a message can have followups
 */
UserMessagesSchema.add({
  followUps: [UserMessagesSchema]
});

/**
 * computes the user's full name
 * to display
 * in worst case, this is the user's email
 * address
 */
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
 * the actual UserSchema
 *
 */
var UserSchema = db.Schema({
      name: {
        first: String,
        last: String
      },
      hashed_password: {type: String, required: true},
      salt: {type: String, required: true},
      preferences: { type: db.Schema.Types.Mixed, default: { common: { locale: 'en', hosts: [] }, docklets: [ 'notification_service/docklets/summary' ] } },
      messages: [ UserMessagesSchema ],
      email: {type: String, 
              lowercase: true,
              required: true,
              index: { unique: true },
              match: /@/ },
      login_log: [ UserLoginLogSchema ],
      last_request: {
        createdAt: Date,
        ip: String
      },
      groups: [{ type: db.Schema.Types.ObjectId, ref: 'Group' } ],
      confirmation: {
        key: String,
        expires: Date,
        last_success: Date,
        tries: { type: Number, default: 3 }
      },
      created: { 
        at: { type: Date, default: Date.now },
        by: { type: db.Schema.Types.ObjectId, ref: 'User' }
      },
      updated: { 
        at: { type: Date, default: Date.now },
        by: { type: db.Schema.Types.ObjectId, ref: 'User' }
      },
      locked: { 
        at: { type: Date, default: Date.now },
        by: { type: db.Schema.Types.ObjectId, ref: 'User' }
      },
      description: String,
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
 */
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
 */
UserSchema.virtual('unreadMessages').get( function(){
  var unread = 0;
  this.messages.forEach( function( message ){
    if( !message.read ) unread+=1;
  });
  return unread;
});;

/**
 * set hashed_password
 *
 * @param {String} password - the unencrypted password to be set
 */
UserSchema.virtual('password').set(function( password ) {
    this._password = password;
    this.salt = this.generateSalt();
    this.hashed_password = this.encryptPassword(password);
})

/**
 * get unenrypted password
 *
 * @return {String} the unencrypted password (exists only for the time of obejct
 * creation)
 */
UserSchema.virtual('password').get(function() { 
  return this._password; 
});

/**
 * authenticate user
 *
 * compares hashed password with given plain text password
 *
 * @param {String} plainTextPassword the plain text password which
 * will be hase-compared against the original password saved to
 * the database
 */
UserSchema.method('authenticate', function(plainTextPassword) {
  return this.encryptPassword(plainTextPassword) === this.hashed_password;
});

/**
 * generate salt
 *
 * generate the password salt
 */
UserSchema.method('generateSalt', function() {
  return Math.round((new Date().valueOf() * Math.random())) + '';
});

/**
 *
 * encrypt password
 *
 * @param {String} password - clear text password string
 * to be encrypted
 */
UserSchema.method('encryptPassword', function(password) {
  return crypto.createHmac('sha1', this.salt).update(password).digest('hex');
});

UserSchema.plugin(jsonSelect, '-hashed_password -salt -confirmation -login_log');

module.exports = db.model('User', UserSchema);
