var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , request = require('supertest')
  , nginuous = helper.nginuous;


describe( 'Domain API', function(){

  before(function(){
    this.app = nginuous();
  });

  describe('GET /domains', function(){

    it('responds with json', function(done){
      request(this.app.express)
      .get('/domains')
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200,done);
    });

  });

});


