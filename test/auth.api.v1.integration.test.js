var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , request = require('superagent')
  , caminio = helper.caminio;

var URL='http://localhost:3000/v1/auth';

describe( 'Auth API '+URL, function(){

  before(function( done ){
    helper.startServer( this, function( test ){
      fixtures.admin.create( function(err, user){
        test.user = user;
        fixtures.Client.create( function( err, client ){
          client.user = user;
          client.save( function( err ){
            test.client = client;
            done();
          });
        })
      });
    });
  });

  describe('GET '+URL+'/login', function(){
  
    it('renders login form', function(done){
      var test = this;
      test.agent
      .get(URL+'/login')
      .end(function(err, res){
        expect(res.status).to.eq(200);
        expect(res.text).to.match(/<form/);
        expect(res.text).to.match(/password/);
        done();
      });
    });

  });

  describe('POST '+URL+'/login', function(){

    describe('wrong', function(){

      it('passwort', function(done){
        var test = this;
        test.agent
        .post(URL+'/login')
        .send({username: this.user.email, password: this.user.password.substr(0,this.user.password.length-2)})
        .end(function(err, res){
          expect(res.status).to.eq(200);
          expect(res.text).to.match(/<form/);
          expect(res.text).to.match(/password/);
          done();
        });
      });

      it('email', function(done){
        var test = this;
        test.agent
        .post(URL+'/login')
        .send({username: this.user.email+'a', password: this.user.password})
        .end(function(err, res){
          expect(res.status).to.eq(200);
          expect(res.text).to.match(/<form/);
          expect(res.text).to.match(/password/);
          done();
        });
      });

      it('all wrong', function(done){
        var test = this;
        test.agent
        .post(URL+'/login')
        .send({username: 'a@localhost.local', password: 'pass'})
        .end(function(err, res){
          expect(res.status).to.eq(200);
          expect(res.text).to.match(/<form/);
          expect(res.text).to.match(/password/);
          done();
        });
      });

    });

    describe('correct login', function(){

      it('passes', function(done){
        var test = this;
        test.agent
        .post(URL+'/login')
        .send({username: this.user.email, password: this.user.password})
        .end(function(err, res){
          expect(res.status).to.eq(200);
          expect(res.text).to.not.match(/<form/);
          expect(res.text).to.not.match(/password/);
          done();
        });
      });

    })

  });

  describe('POST '+URL+'/oauth/request_token', function(){

    describe('invalid_request', function(){

      it('no client info at all', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/request_token')
        .send({redirect_uri: '/oauth/access_token'})
        .end( function( err, res ){
          expect(res.status).to.eq(400);
          done();
        })
      });

      it('no client_id', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/request_token')
        .send({redirect_uri: '/oauth/access_token', client_secret: test.client.secret, response_type: 'code'})
        .end( function( err, res ){
          expect(res.status).to.eq(400);
          done();
        })
      });

      it('no client_secret', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/request_token')
        .send({redirect_uri: '/oauth/access_token', client_id: test.client.id, response_type: 'code'})
        .end( function( err, res ){
          expect(res.status).to.eq(400);
          done();
        })
      });

    });

    describe('passes', function(){

      it('gets token and secret', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/request_token')
        .send({
          redirect_uri: '/oauth/access_token',
          client_id: test.client.id,
          client_secret: test.client.secret,
          response_type: 'code'
        })
        .end( function( err, res ){
          expect(res.status).to.eq(200);
          expect(res.header['content-type']).to.match(/json/);
          expect(JSON.parse(res.text)).to.have.property('code');
          done();
        });

      });

    });

  });
  
  describe('POST '+URL+'/oauth/access_token', function(){

    describe('invalid_request', function(){

      it('no client info at all', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/access_token')
        .send({redirect_uri: '/oauth/access_token'})
        .end( function( err, res ){
          expect(res.status).to.eq(400);
          done();
        })
      });

      it('no client_id', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/access_token')
        .send({redirect_uri: '/oauth/access_token', client_secret: test.client.secret, response_type: 'code'})
        .end( function( err, res ){
          expect(res.status).to.eq(400);
          done();
        })
      });

      it('no client_secret', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/access_token')
        .send({redirect_uri: '/oauth/access_token', client_id: test.client.id, response_type: 'code'})
        .end( function( err, res ){
          expect(res.status).to.eq(400);
          done();
        })
      });

      it('no request_token', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/access_token')
        .end(function(err,res){
          expect(res.status).to.eq(400);
          done();
        });
      });

    });

    describe('passes', function(){

      before(function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/request_token')
        .send({
          redirect_uri: 'http://localhost:3000/v1/accounts/me',
          client_id: test.client.id,
          client_secret: test.client.secret,
          response_type: 'code'
        })
        .end( function( err, res ){
          test.requestCode = JSON.parse(res.text).code;
          done();
        });
      });

      it('gets token and secret', function(done){
        var test = this;
        test.agent
        .post(URL+'/oauth/access_token')
        .send({
          redirect_uri: 'http://localhost:3000/v1/accounts/me',
          client_id: test.client.id,
          client_secret: test.client.secret,
          code: test.requestCode,
          response_type: 'code'
        })
        .end( function( err, res ){
          expect(res.status).to.eq(200);
          expect(JSON.parse(res.text)).to.have.property('access_token');
          expect(JSON.parse(res.text)).to.have.property('refresh_token');
          expect(JSON.parse(res.text)).to.have.property('expires_in');
          expect(JSON.parse(res.text).access_token).to.have.length(8);
          done();
        })
      });

    });

  });

  describe('GET '+URL+'/test', function(){
  
    before(function(done){
      var test = this;
      test.agent
      .post(URL+'/oauth/request_token')
      .send({
        redirect_uri: URL+'/test',
        client_id: test.client.id,
        client_secret: test.client.secret,
        response_type: 'code'
      })
      .end( function( err, res ){
        test.requestCode = 
        test.agent
        .post(URL+'/oauth/access_token?')
        .send({
          redirect_uri: URL+'/test',
          client_id: test.client.id,
          client_secret: test.client.secret,
          code: JSON.parse(res.text).code,
          response_type: 'code'
        })
        .end( function( err, res ){
          test.accessToken = JSON.parse(res.text).access_token;
          done();
        });
      });
    });

    describe('fails', function(){
    
      it('no authorization information', function(done){
        var test = this;
        test.agent
        .get(URL+'/test')
        .end( function( err, res ){
          expect(res.status).to.eq(400);
          done();
        });
      });
    
      it('wrong authorization', function(done){
        var test = this;
        test.agent
        .get(URL+'/test')
        .set('Authorization', 'Bearer woiwetu29')
        .end( function( err, res ){
          expect(res.status).to.eq(401);
          done();
        });
      });

    })

    describe('passes', function(){
    
      it('gets the resource', function(done){
        var test = this;
        test.agent
        .get(URL+'/test')
        .set('Authorization', 'Bearer '+test.accessToken)
        .end( function( err, res ){
          expect(res.status).to.eq(200);
          var user = JSON.parse(res.text);
          expect(user.id).to.eq(test.user.id);
          done();
        });
      });

    });

    describe('passes with token', function(){

      it('gets the resource with token', function(done){
        var test = this;
        test.agent
        .get(URL+'/test_login_or_token')
        .set('Authorization', 'Bearer '+test.accessToken)
        .end( function( err, res ){
          expect(res.status).to.eq(200);
          var user = JSON.parse(res.text);
          expect(user.id).to.eq(test.user.id);
          done();
        });
      });

    });

    describe('passes with login', function(){

      before( function(done){
        var test = this;
        test.agent
        .get(URL+'/logout')
        .end( function(){
          test.agent
          .post(URL+'/login')
          .send({username: test.user.email, password: test.user.password})
          .end(function(err, res){
            done();
          });

        });
      });

      it('gets the resource with login', function(done){
        var test = this;
        test.agent
        .get(URL+'/test_login_or_token')
        .end( function( err, res ){
          expect(res.status).to.eq(200);
          var user = JSON.parse(res.text);
          expect(user.id).to.eq(test.user.id);
          done();
        });
      });

    });

  });

});