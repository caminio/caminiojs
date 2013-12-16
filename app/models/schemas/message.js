/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var mongoose = require('mongoose');

/**
 * MessageSchema
 *
 * a message is for inner communication
 * between users
 */
var MessageSchema = new mongoose.Schema({
  content: String,
  read: {type: Boolean, default: false},
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now }
});

/**
 * a message can have followups
 */
MessageSchema.add({
  followUps: [ MessageSchema ]
});

module.exports = MessageSchema;

