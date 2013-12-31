/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var orm = require('../../').orm
  , AuthFailureSchema = require('./schemas/auth_failure');

/**

A request token is obtained, if a client/consumer (an application)
want's to get access to nginios resources or to another nginios
instance's resources.

Mongoose Model

@class RequestToken
@constructor

**/
var RequestTokenSchema = new orm.Schema({
  ip_address: String,
  user: { type: orm.Schema.Types.ObjectId, ref: 'User' },
  client: { type: orm.Schema.Types.ObjectId, ref: 'Client', required: true },
  token: String,
  secret: String,
  redirect_uri: String,
  tries: [ AuthFailureSchema ],
  approved_at: Date,
  created_at: { type: Date, default: Date.now }
});


module.exports = RequestTokenSchema;
