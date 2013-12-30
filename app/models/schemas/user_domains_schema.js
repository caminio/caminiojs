/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var mongoose = require('mongoose');

/**

  @class UserDomainsSchema
  @constructor

**/
var UserDomainsSchema = new mongoose.Schema({
  can_delete: { type: Boolean, default: false },
  can_manage: { type: Boolean, default: false },
  domain: { type: mongoose.Schema.Types.ObjectId, ref: 'Domain' },
  created: { 
    at: { type: Date, default: Date.now },
    by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
  },
  updated: { 
    at: { type: Date, default: Date.now },
    by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
  }
});

module.exports = UserDomainsSchema;

