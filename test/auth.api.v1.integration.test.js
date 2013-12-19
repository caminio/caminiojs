var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , request = require('supertest')
  , nginuous = helper.nginuous;


describe( 'Auth API v1', function(){

  before(function( done ){
    this.app = nginuous();
    var self = this;
    fixtures.user.create( function(err, user){
      self.user = user;
      done();
    });
  });

  describe('POST /v1/auth', function(){

    it('authorizes a user and returns api_token', function(done){
      request(this.app.express)
      .post('/v1/auth')
      .set('Accept', 'application/json')
      .send({email: this.user.email, password: this.user.password})
      .expect('Content-Type', /json/)
      .expect(200,done);
    });

  });

});
