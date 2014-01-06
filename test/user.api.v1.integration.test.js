var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , request = require('superagent')
  , nginios = helper.nginios;

var URL='http://localhost:3000/v1/users';

describe( 'User API '+URL, function(){

  before(function( done ){
    helper.startServer( this, function( test ){
      fixtures.admin.create( function(err, user){
        test.user = user;
        test.agent
        .post('http://localhost:3000/v1/auth/login')
        .send({
          username: user.email,
          password: user.password
        })
        .end( function( err, res ){
          done(err);
        });

      });
    });
  });

  describe('GET '+URL, function(){
  
    it('returns array of users', function(done){
      var test = this;
      test.agent
      .get(URL+'/')
      .end(function(err, res){
        expect(res.status).to.eq(200);
        var jRes = JSON.parse(res.text);
        expect(jRes).to.have.property('items');
        expect(jRes.items).to.be.a('array');
        done();
      });
    });

  });

  describe('POST '+URL, function(){
 
    beforeEach( function(done){
      nginios.orm.models.User.remove({ email: 'maria.shelley@example.com' }, function( err ){
        done(err);
      })
    });

    it('succeeds with password', function(done){
      var test = this;
      test.agent
      .post(URL+'/')
      .send({
        user: {
          name: { full: 'Maria Shelley' },
          email: 'maria.shelley@example.com',
          password: 'mariaTest-5'
        }
      })
      .end(function(err, res){
        expect(res.status).to.eq(200);
        var jRes = JSON.parse(res.text);
        expect(jRes).to.have.property('item');
        expect(jRes.item).to.have.property('id');
        done();
      });
    });

    it('fails without email', function(done){
      var test = this;
      test.agent
      .post(URL+'/')
      .send({
        user: {
          name: { full: 'Maria Shelley' },
          password: 'mariaTest-5'
        }
      })
      .end(function(err, res){
        expect(res.status).to.eq(400);
        done();
      });
    });

  });

  describe('PUT '+URL, function(){

    before( function(done){
      var test = this;
      fixtures.user.create( function( err, user ){
        test.user = user;
        done();
      });
    });

    it('updates the user successfully', function(done){
      var test = this;
      test.agent
      .put(URL+'/'+test.user.id)
      .send({
        user: {
          name: { first: 'Maria', last: 'Kern' }
        }
      })
      .end(function(err, res){
        expect(res.status).to.eq(200);
        var jRes = JSON.parse(res.text);
        expect(jRes).to.have.property('item');
        expect(jRes.item.name.full).to.eq('Maria Kern');
        done();
      });
    });

  });

  describe('LOCK '+URL+'/:id/lock', function(){

    before( function(done){
      var test = this;
      fixtures.user.create( function( err, user ){
        test.user = user;
        done();
      });
    });

    it('succeeds', function(done){
      var test = this;
      test.agent
      .put(URL+'/'+test.user.id+'/lock')
      .end(function(err, res){
        expect(res.status).to.eq(200);
        var jRes = JSON.parse(res.text);
        expect(jRes).to.have.property('item');
        expect(jRes.item.locked).to.have.property('at');
        done();
      });
    });

  });

  describe('DELETE '+URL+'/:id', function(){

    before( function(done){
      var test = this;
      fixtures.user.create( function( err, user ){
        test.user = user;
        done();
      });
    });

    it('succeeds', function(done){
      var test = this;
      test.agent
      .del(URL+'/'+test.user.id)
      .end(function(err, res){
        expect(res.status).to.eq(200);
        var jRes = JSON.parse(res.text);
        expect(jRes).to.have.property('item');
        done();
      });
    });

  });


});
