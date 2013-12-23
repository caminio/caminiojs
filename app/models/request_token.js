/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var orm = require('../../').orm
  , AuthFailureSchema = require('./schemas/auth_failure');

/**

A request token is obtained, if a client/consumer (an application)
want's to get access to nginuous resources or to another nginuous
instance's resources.

Mongoose Model

@class RequestToken
@constructor

**/
var RequestTokenSchema = new orm.Schema({
  ip_address: String,
  user: { type: orm.Schema.Types.ObjectId, ref: 'User' },
  client: { type: orm.Schema.Types.ObjectId, ref: 'Client' },
  token: String,
  secret: String,
  redirect_uri: String,
  tries: [ AuthFailureSchema ],
  approved: {
    at: Date
  },
  expires: {
    at: Date
  },
});


module.exports = RequestTokenSchema;
