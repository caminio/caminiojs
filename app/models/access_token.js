/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var orm = require('../../').orm
  , AuthFailureSchema = require('./schemas/auth_failure');

/**

An access token is a permanent token granting a client
to communicate with this nginious instance. It can also
have an expires property to define a life time.

@class AccessToken
@constructor

**/

var AccessTokenSchema = new orm.Schema({
  ip_address: String,
  token: String,
  secret: String,
  user: { type: orm.Schema.Types.ObjectId, ref: 'User' },
  client: { type: orm.Schema.Types.ObjectId, ref: 'Client' },
  redirect_url: String,
  tries: [ AuthFailureSchema ],
  created_at: { type: Date, default: Date.now },
  expires_at: Date
});


module.exports = AccessTokenSchema;
