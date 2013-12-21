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

    describe('wrong', function(){
    
      it('passwort', function(done){
        request(this.app.express)
        .post('/v1/auth')
        .set('Accept', 'application/json')
        .send({email: this.user.email, password: this.user.password.substr(0,this.user.password.length-2)})
        .expect('Content-Type', /json/)
        .end(function(err, res){
          expect(res.status).to.eq(401);
          expect(JSON.parse(res.text)).to.have.property('error');
          expect(JSON.parse(res.text).error.status).to.eq(401);
          expect(JSON.parse(res.text).error.name).to.eq('denied');
          expect(JSON.parse(res.text).error.message).to.eq('access denied');
          done();
        });
      });

      it('email', function(done){
        request(this.app.express)
        .post('/v1/auth')
        .set('Accept', 'application/json')
        .send({email: this.user.email+'a', password: this.user.password})
        .expect('Content-Type', /json/)
        .end(function(err, res){
          expect(res.status).to.eq(401);
          expect(JSON.parse(res.text)).to.have.property('error');
          expect(JSON.parse(res.text).error.status).to.eq(401);
          expect(JSON.parse(res.text).error.name).to.eq('denied');
          expect(JSON.parse(res.text).error.message).to.eq('access denied');
          done();
        });
      });

      it('all wrong', function(done){
        request(this.app.express)
        .post('/v1/auth')
        .set('Accept', 'application/json')
        .send({email: 'a@localhost.local', password: 'pass'})
        .expect('Content-Type', /json/)
        .end(function(err, res){
          expect(res.status).to.eq(401);
          expect(JSON.parse(res.text)).to.have.property('error');
          expect(JSON.parse(res.text).error.status).to.eq(401);
          expect(JSON.parse(res.text).error.name).to.eq('denied');
          expect(JSON.parse(res.text).error.message).to.eq('access denied');
          done();
        });
      });

    });

    describe('locked', function(){

      it('another ip address is logged in already', function(done){
        
        var self = this;
        this.user.auth_token.ip_address = '127.0.0.2';
        this.user.save( next );

        function next( err ){
          request(self.app.express)
            .post('/v1/auth')
            .set('Accept', 'application/json')
            .send({email: self.user.email, password: self.user.password})
            .expect('Content-Type', /json/)
            .end(function(err, res){
              expect(res.status).to.eq(423);
              expect(JSON.parse(res.text)).to.have.property('error');
              expect(JSON.parse(res.text).error.status).to.eq(423);
              expect(JSON.parse(res.text).error.name).to.eq('locked');
              expect(JSON.parse(res.text).error.message).to.eq('account locked by another ip for 0 minutes');
              done();
            });
        }

      });

    });

  });

});
