/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var orm = require('../../').orm;

/**
A client as an application (also called consumer), that processes
operations for the actual user

@class Client
@constructor

The associated user
@property user
@type Object

The scope for this client
@property scope
@type Array

**/
var ClientSchema = new orm.Schema({
  ip_address: String,
  token: String,
  secret: String,
  name: { type: String, index: { unique: true } },
  user: { type: orm.Schema.Types.ObjectId, ref: 'User' },
  scope: { type: Array, default: ['*'] },
  callbackURL: String,
  expires: {
    at: Date
  },
});


module.exports = ClientSchema;
