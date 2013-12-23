/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fixtures = require('nginious-fixtures')
  , utils = require('../../lib/nginious/utils');

fixtures.define('Client', {
  name: function(){ return 'test-client-'+Math.random(1000)*(new Date().getTime()).toString(); },
  token:  function(){ return utils.uid(32) },
  secret: function(){ return utils.uid(32) }
});
