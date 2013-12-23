var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , request = require('superagent')
  , nginuous = helper.nginuous;

var URL='http://localhost:3000/v1/auth';

describe( 'Auth API '+URL, function(){
/*
  before(function( done ){
    helper.startServer( this, function( test ){
      fixtures.user.create( function(err, user){
        test.user = user;
        fixtures.Client.create( function( err, client ){
          test.client = client;
          helper.setupOauth( test, URL );
          done();
        })
      });
    });
  });

    describe('POST '+URL+'/oauth/request_token', function(){
    
      it('gets token and scret', function(done){
        var test = this;
        test.oauth.getOAuthRequestToken( function( err, request_token, request_token_secret, res ){
          expect(err).to.be.a('null');
          expect(request_token).to.be.a('string');
          expect(request_token).to.have.length.of(8);
          expect(request_token_secret).to.be.a('string');
          expect(request_token_secret).to.have.length.of(32);
          done();
        });
      });

    });

    describe('POST '+URL+'/oauth/access_token', function(){
    
      before(function(done){
        var test = this;
        test.oauth.getOAuthRequestToken( function( err, request_token, request_token_secret, res ){
          test.request_token = request_token;
          test.request_token_secret = request_token_secret;
          done();
        });
      
      });

      it('gets token and scret', function(done){
        var test = this;
        test.oauth.getOAuthAccessToken( test.request_token, test.request_token_secret, 
          function (err, access_token, access_token_secret, results){
            console.log(err);
            expect(err).to.be.a('null');
            expect(access_token).to.be.a('string');
            expect(access_token).to.have.length.of(8);
          });
        });

    });
    */
/*
  describe('GET '+URL+'/dialog/authorize', function(){

    it('redirects to user login before showing the authorize form', function(done){
      var test = this;
      test.agent
      .get(URL+'/dialog/authorize')
      .end(function(err, res){
        expect(res.status).to.eq(200);
        expect(res.text).to.match(/password/);
        done();
      });

    });

    //it('grants access to a known client', function( done ){
    //  var test = this;
    //  test.oauth.getOAuthRequestToken( function( err, request_token, request_token_secret, res ){
    //    test.oauth.getOAuthAccessToken( request_token, request_token_secret, function (err, access_token, access_token_secret, results){
    //      console.log( access_token );
    //      test.oauth.get( URL.replace('/auth','/accounts/me'),
    //        access_token, 
    //        access_token_secret,
    //        function( err, data, res ){
    //          console.log(err);
    //          console.log(data);
    //          expect(res.status).to.eq(200);
    //          done();
    //        });

    //    });
    //  });
    //});

    //it('shows authorization form after login', function(done){
    //  var self = this;
    //  self.request
    //  .get('/'+V+'/auth/dialog/authorize')
    //  .end(function(){
    //    self.request
    //    .post('/'+V+'/auth/login')
    //    .send({username: self.user.email, password: self.user.password})
    //    .end(function(err, res){
    //      self.cookie = res.headers['set-cookie'];
    //      expect(res.status).to.eq(302);
    //      self.request
    //      .get('/'+V+'/auth/dialog/authorize?oauth_token=bla&oauth_callback=/ow')
    //      .set('cookie', self.cookie)
    //      .end(function(err, res){
    //        console.log(res.text);
    //        expect(res.status).to.eq(200);
    //        done();
    //      });
    //    });
    //  
    //  })
    //});

  });
*/

  //  describe('wrong', function(){
  //  
  //    it('passwort', function(done){
  //      request(this.app.express)
  //      .post('/v1/auth')
  //      .set('Accept', 'application/json')
  //      .send({email: this.user.email, password: this.user.password.substr(0,this.user.password.length-2)})
  //      .expect('Content-Type', /json/)
  //      .end(function(err, res){
  //        expect(res.status).to.eq(401);
  //        expect(JSON.parse(res.text)).to.have.property('error');
  //        expect(JSON.parse(res.text).error.status).to.eq(401);
  //        expect(JSON.parse(res.text).error.name).to.eq('denied');
  //        expect(JSON.parse(res.text).error.message).to.eq('access denied');
  //        done();
  //      });
  //    });

  //    it('email', function(done){
  //      request(this.app.express)
  //      .post('/'+V+'/auth')
  //      .set('Accept', 'application/json')
  //      .send({email: this.user.email+'a', password: this.user.password})
  //      .expect('Content-Type', /json/)
  //      .end(function(err, res){
  //        expect(res.status).to.eq(401);
  //        expect(JSON.parse(res.text)).to.have.property('error');
  //        expect(JSON.parse(res.text).error.status).to.eq(401);
  //        expect(JSON.parse(res.text).error.name).to.eq('denied');
  //        expect(JSON.parse(res.text).error.message).to.eq('access denied');
  //        done();
  //      });
  //    });

  //    it('all wrong', function(done){
  //      request(this.app.express)
  //      .post('/'+V+'/auth')
  //      .set('Accept', 'application/json')
  //      .send({email: 'a@localhost.local', password: 'pass'})
  //      .expect('Content-Type', /json/)
  //      .end(function(err, res){
  //        expect(res.status).to.eq(401);
  //        expect(JSON.parse(res.text)).to.have.property('error');
  //        expect(JSON.parse(res.text).error.status).to.eq(401);
  //        expect(JSON.parse(res.text).error.name).to.eq('denied');
  //        expect(JSON.parse(res.text).error.message).to.eq('access denied');
  //        done();
  //      });
  //    });

  //  });

  //  describe('locked', function(){

  //    it('another ip address is logged in already', function(done){
  //      
  //      var self = this;
  //      this.user.auth_token.ip_address = '127.0.0.2';
  //      this.user.save( next );

  //      function next( err ){
  //        request(self.app.express)
  //          .post('/'+V+'/auth')
  //          .set('Accept', 'application/json')
  //          .send({email: self.user.email, password: self.user.password})
  //          .expect('Content-Type', /json/)
  //          .end(function(err, res){
  //            expect(res.status).to.eq(423);
  //            expect(JSON.parse(res.text)).to.have.property('error');
  //            expect(JSON.parse(res.text).error.status).to.eq(423);
  //            expect(JSON.parse(res.text).error.name).to.eq('locked');
  //            expect(JSON.parse(res.text).error.message).to.eq('account locked by another ip for 0 minutes');
  //            done();
  //          });
  //      }

  //    });

  //  });

  //  //describe('content through auth_token', function(){
  //  // 
  //  //  before( function(done){
  //  //    var self = this;
  //  //    request(self.app.express)
  //  //      .post('/'+V+'/auth')
  //  //      .set('Accept', 'application/json')
  //  //      .send({email: self.user.email, password: self.user.password})
  //  //      .end(function(err,res){
  //  //        self.auth_token = JSON.parse('auth_token');
  //  //      });
  //  //  });

  //  //  it('GET /'+V+'/account', function(){
  //  //    request(self.app.express)
  //  //      .get('/'+V+'/auth/test')
  //  //      .set('Accept', 'application/json')
  //  //      .send({auth_token: this.auth_token})
  //  //      .expect('Content-Type', /json/)
  //  //      .end(function(err, res){
  //  //        expect(res.status).to.eq(200);
  //  //        expect(JSON.parse(res.text)).to.have.property('');
  //  //        done();
  //  //      });
  //  //    
  //  //  });

  //  //});

  ////});

});
