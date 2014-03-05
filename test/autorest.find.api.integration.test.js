/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var superagent = require('superagent');

var helper = require('./helper');
var fixtures = helper.fixtures;
var caminio;
var autorest;
var expect = helper.chai.expect;

describe('Autorest find functions', function(){

  before( function(done){
    helper.initApp( this, function(){
      caminio = helper.caminio;   
      helper.cleanup(caminio, function(){
        autorest = require( process.cwd()+'/lib/controller/autorest' )( caminio );
        done();
      });
    });
  }); 

  describe('without operators', function(){

    before( function( done ){
      var test = this;
      helper.cleanup(caminio, function(){
        fixtures['My::Butter'].create(function( err, butter ){
          test.butter = butter;
          fixtures['My::Butter'].create( {amount: 3}, function( err, b ){
            done();
          });
        });
      });
    });

    it('nothing given - find{}', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        expect(res.body).to.have.length(2);
        done();
      });
    });

  });

  describe('with regexpression operators', function(){
    
    before( function( done ){
      var test = this;
      helper.cleanup(caminio, function(){
        fixtures['My::Butter'].create(function( err, butter ){
          test.butter = butter;
          fixtures['My::Butter'].create( {amount: 3}, function( err, b ){
            done();
          });
        });
      });
    });

    it('parts of words - regexp(/.../)', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?name=regexp(/ram/)')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        expect(res.body).to.have.length(2);
        done();
      });
    });

  });

  describe('with mongo operators', function(){

    before( function( done ){
      var test = this;
      helper.cleanup(caminio, function(){
        fixtures['My::Butter'].create(function( err, butter ){
          test.butter = butter;
          fixtures['My::Butter'].create( {name: 'test', amount: 3}, function( err, b ){
            done();
          });
        });
      });
    });

    it('less than operator - key lt( ... ) ', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?amount=lt(100)')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        expect(res.body).to.have.length(1);
        done();
      });
    });

    it('less than operator - key ne(null) ', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?amount=ne(null)')
      .end( function(err,res){
        console.log(res.body);
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        expect(res.body).to.have.length(2);
        done();
      });
    });

    it('less than equal operator - key lte( ... ) ', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?amount=lte(3)')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        expect(res.body).to.have.length(1);
        done();
      });
    });

    it('greater than operator - key gt( ... ) ', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?amount=gt(100)')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        expect(res.body).to.have.length(1);
        done();
      });
    });

    it('greater than equal operator - key gte( ... ) ', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?amount=gte(134)')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        expect(res.body).to.have.length(1);
        done();
      });
    });

    it('or operator - or [{ key: ... }, { key: ... }]', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find/')
      .send({
        or: [
        { name: 'test' },
        { name: 'regexp(/ram/)'},
        { amount: 134},
        { amount: 3}
        ]
      })
      .end( function(err,res){
        expect(res.body).to.have.length(2);
        expect(res.status).to.eql(200);
        done();
      });
    });

    it('and operator - { key0: ..., key1: ... }', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find/')
      .send({
        name: 'test',
        amount: 3
      })
      .end( function(err,res){        
        expect(res.body).to.have.length(1);
        expect(res.status).to.eql(200);
        done();
      });
    });

    it('in operator - key in([..., ...]) }', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?name=in(test,rama)')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.have.length(2);
        done();
      });
    });

  });

  describe('with combined operators', function(){

    before( function( done ){
      var test = this;
      fixtures['My::Butter'].create(function( err, butter ){
        test.butter = butter;
        fixtures['My::Butter'].create( {amount: 3}, function( err, b ){
          done();
        });
      });
    });

    it('or and lt', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find/')
      .send({
        or: [
        { name: 'test' },
        { name: 'regexp(/ram/)'},
        { amount: 134},
        { amount: 'lt(3)'}
        ]
      })
      .end( function(err,res){
        expect(res.body).to.have.length(4);
        expect(res.status).to.eql(200);
        done();
      });
    });

    it('and and gt', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find/')
      .send({
        name: 'rama',
        amount: 'gte(3)'
      })
      .end( function(err,res){        
        expect(res.body).to.have.length(3);
        expect(res.status).to.eql(200);
        done();
      });
    });

  });

  it('gets database errors from invalid queries - amount: gh(500)', function(done){
    var test = this;
    superagent.agent()
    .get(helper.url+'/butter/find?amount=gh(500)')
    .end( function(err,res){
      expect(res.status).to.eql(500);
      done();
    });
  });


});