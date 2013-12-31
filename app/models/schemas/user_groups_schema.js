/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var mongoose = require('mongoose');

/**

  @class UserGroupsSchema
  @constructor

**/
var UserGroupsSchema = new mongoose.Schema({
  can_delete: { type: Boolean, default: false },
  can_manage: { type: Boolean, default: false },
  group: { type: mongoose.Schema.Types.ObjectId, ref: 'Group' },
  created: { 
    at: { type: Date, default: Date.now },
    by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
  },
  updated: { 
    at: { type: Date, default: Date.now },
    by: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
  }
});

module.exports = UserGroupsSchema;

