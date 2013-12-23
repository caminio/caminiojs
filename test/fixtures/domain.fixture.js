/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var fixtures = require('nginious-fixtures');

fixtures.define('domain', {
  name: function(){ return 'kings'+(parseInt((new Date()).getTime()*Math.random(1000))).toString()+'.com' },
  description: '',
  owner: function(){ return fixtures.user.build(); }
});
