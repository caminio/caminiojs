/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */


var mongoose = require('mongoose');

var TestModelSchema = mongoose.Schema({
  name: String
});

module.exports = mongoose.model('TestModel', TestModelSchema);
