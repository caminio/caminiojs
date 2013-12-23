/**
 * nginious test helper
 */

var helper = {};

helper.nginious = require('../');

helper.fixtures = require('nginious-fixtures');
helper.fixtures.readFixtures();
// enable ORM (mongoose)
helper.fixtures.enableORM( helper.nginious );

helper.chai = require('chai');
helper.chai.Assertion.includeStack = true;

var running;

helper.startServer = function( test, done ){

  if( running ){
    test.agent = superagent.agent();
    done(test);
  }

  var superagent = require('superagent');

  test.app = helper.nginious();
  test.app.server.start( function(){
    running = true;
    test.agent = superagent.agent();
    done(test);
  });

}

helper.setupOauth = function( test, url ){

  var OAuth = require('OAuth');

  test.oauth = new OAuth.OAuth(
      url+'/oauth/request_token',
      url+'/oauth/access_token',
      test.client.token,
      test.client.secret,
      '1.0',
      null,
      'HMAC-SHA1'
    );

}


module.exports = helper;
