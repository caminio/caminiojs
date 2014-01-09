/**
 * caminio test helper
 */

var helper = {};

helper.caminio = require('../');

helper.fixtures = require('caminio-fixtures');
helper.fixtures.readFixtures();
// enable ORM (mongoose)
helper.fixtures.enableORM( helper.caminio );

helper.chai = require('chai');
helper.chai.Assertion.includeStack = true;

helper.startServer = function( test, done ){

  if( test.superagent ){
    test.agent = test.superagent.agent();
    return done(test);
  }

  test.superagent = require('superagent');

  if( test.server )
    test.server.close();

  test.app = helper.caminio();
  test.server = test.app.server.start( function(){
    test.running = true;
    test.agent = test.superagent.agent();
    done(test);
  });

}

module.exports = helper;
