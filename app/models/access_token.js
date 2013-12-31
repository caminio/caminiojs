/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var orm = require('../../').orm
  , AuthFailureSchema = require('./schemas/auth_failure');

/**

An access token is a permanent token granting a client
to communicate with this nginios instance. It can also
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
  expires_in: Date,
  refresh_token: String
});

AccessTokenSchema.method('toToken', function(){
  return {
    access_token: this.token,
    expires_in: this.expires_in,
    refresh_token: this.refresh_token
  }
})

module.exports = AccessTokenSchema;
