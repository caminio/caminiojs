/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var orm = require('../../../').orm;

/**
 * AuthTokenSchema
 *
 * a basic authentication grant to an
 * application or web browser
 *
 */
var AuthFailureSchema = new orm.Schema({
  ip_address: String,
  at: { type: Date, default: Date.now },
  tries: Number
});


module.exports = AuthFailureSchema;
