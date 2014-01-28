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

describe('Autorest', function(){

  before( function(done){
    helper.initApp( this, function(){ 
      caminio = helper.caminio; 
      autorest = require( process.cwd()+'/lib/controller/autorest' )( caminio );
      //console.log(caminio.express.routes );
      done();
    });
  }); 

  describe('autorest route must match a modelName', function(){

    it('fails', function(){
      expect( function(){
        autorest.create( 'NonExistentModel', '/non_existent' );
      }).to.throw(/Missing model/);
    });

  });
  
  describe('create restful routes for ButterController', function(){

    before( function( done ){
      var test = this;
      fixtures['My::Butter'].create(function( err, butter ){
        test.butter = butter;
        done();
      });
    });

    it('index', function(done){
      superagent.agent()
      .get(helper.url+'/butter')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.instanceOf(Array);
        done();
      });
    });

    it('create', function(done){
      superagent.agent()
      .post(helper.url+'/butter')
      .send({ 'my/butter': { name: 'Noname', amount: 100 } })
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.have.property('name');
        done();
      });
    });

    it('update', function(done){
      var test = this;
      test.butter.amount = 50;
      superagent.agent()
      .put(helper.url+'/butter/'+this.butter.id)
      .send({ 'my/butter': { amount: test.butter.amount } })
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body.amount).to.eql(test.butter.amount);
        done();
      });
    });

    it('show', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/'+this.butter.id)
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body.amount).to.eql(test.butter.amount);
        expect(res.body.name).to.eql(test.butter.name);
        done();
      });
    });

    it('find', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        done();
      });
    });

    it('destroy', function(done){
      var test = this;
      superagent.agent()
      .del(helper.url+'/butter/'+this.butter.id)
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.empty;
        done();
      });
    });
  });


});