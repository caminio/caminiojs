/** 
 * @Author: David Reinisch
 * @Company: TASTENWERK e.U.
 * @Copyright: 2014 by TASTENWERK
 * @License: Commercial
 *
 * @Date:   2014-06-06 13:35:12
 *
 * @Last Modified by:   David Reinisch
 * @Last Modified time: 2014-06-06 16:13:03
 *
 * This source code is not part of the public domain
 * If server side nodejs, it is intendet to be read by
 * authorized staff, collaborator or legal partner of
 * TASTENWERK only
 */

'use strict';

var helper = require('./helper'), 
    caminio,
    expect = helper.chai.expect;

var user;

var notify,
    mailer;

/* jshint -W024 */
/* jshint expr:true */
describe('notify usage test', function(){

  before( function(done){
    helper.initApp( this, function(){ 
      caminio = helper.caminio; 
      notify = require('../lib/notify')( caminio );
      helper.cleanup( caminio, function(){
        done();
      }); 
    });
  });
  
  it('needs a set namespace in an user object', function(){
    user = { name: 'testuser', notify: 'test' };
    expect( user.notify ).to.exist;
  }); 

  it('needs a registered service', function(){
    mailer = require('../lib/mailer')( caminio );
    notify.registerService( 'mailer', mailer );
  });

  it('throws an error if the namespace is not defined', function(){
    try{
      notify( 
        'other', 
        'mailer', 
        user 
      );
    } catch( ex ){
      expect( ex ).to.exist;
    }
  });

  it('throws an error if the service is not supported', function(){
    try{
      notify( 
        'test', 
        'other', 
        user 
      );
    } catch( ex ){
      expect( ex ).to.exist;
    }
  });

  it('sends an email if the mailer service is called', function(){
    notify( 
      'test', 
      'mailer', 
      user,
      'david@test.test',
      'test',
      {
        locals: {
          user: user
        },
        text: 'Hello World'
      },
      function( err ){
        expect( err ).to.be.null;
      } 
    );
  });

});