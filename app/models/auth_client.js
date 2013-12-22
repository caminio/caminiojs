/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var orm = require('../../').orm;

/**
 * AuthTokenSchema
 *
 * a basic authentication grant to an
 * application or web browser
 *
 */
var ClientTokenSchema = new orm.Schema({
  ip_address: String,
  token: String,
  user_id: { type: orm.Schema.Types.ObjectId, ref: 'User' },
  client_secret: String,
  consumer_secret: String,
  callbackURL: String,
  expires: {
    at: Date
  },
});


module.exports = ClientTokenSchema;
