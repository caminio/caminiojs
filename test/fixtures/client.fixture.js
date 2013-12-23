/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fixtures = require('nginuous-fixtures')
  , utils = require('../../lib/nginuous/utils');

fixtures.define('Client', {
  name: function(){ return 'test-client-'+Math.random(1000)*(new Date().getTime()).toString(); },
  token:  function(){ return utils.uid(32) },
  secret: function(){ return utils.uid(32) }
});
