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

  describe('create restful routes for ButterController', function(){

    before( function( done ){
      var test = this;
      fixtures['My::Butter'].create(function( err, butter ){
        test.butter = butter;
        fixtures['My::Butter'].create( {amount: 3}, function( err, b ){
          done();
        });
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



    it('finds regexp', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?name=regexp(/ram/)')
      .end( function(err,res){
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        done();
      });
    });


    it('finds lt (less than)', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?amount=lt(100)')
      .end( function(err,res){
        console.log(res.body);
        expect(res.status).to.eql(200);
        expect(res.body).to.be.an.instanceOf(Array);
        done();
      });
    });

    it('does not find gh(500)', function(done){
      var test = this;
      superagent.agent()
      .get(helper.url+'/butter/find?amount=gh(500)')
      .end( function(err,res){
        expect(res.status).to.eql(400);
        done();
      });
    });

  });


});