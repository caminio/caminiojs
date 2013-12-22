/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var orm = require('../../').orm
  , AuthFailureSchema = require('./schemas/auth_failure');

/**
 * AuthTokenSchema
 *
 * a basic authentication grant to an
 * application or web browser
 *
 */
var AuthTokenSchema = new orm.Schema({
  ip_address: String,
  token: String,
  user_id: { type: orm.Schema.Types.ObjectId, ref: 'User' },
  client_id: String,
  client_secret: String,
  callbackURL: String,
  tries: [ AuthFailureSchema ],
  expires: {
    at: Date
  },
});


module.exports = AuthTokenSchema;
