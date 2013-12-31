/**
 * nginios test helper
 */

var helper = {};

helper.nginios = require('../');

helper.fixtures = require('nginios-fixtures');
helper.fixtures.readFixtures();
// enable ORM (mongoose)
helper.fixtures.enableORM( helper.nginios );

helper.chai = require('chai');
helper.chai.Assertion.includeStack = true;

var running;

helper.startServer = function( test, done ){

  if( running ){
    test.agent = superagent.agent();
    done(test);
  }

  var superagent = require('superagent');

  test.app = helper.nginios();
  test.app.server.start( function(){
    running = true;
    test.agent = superagent.agent();
    done(test);
  });

}

module.exports = helper;
