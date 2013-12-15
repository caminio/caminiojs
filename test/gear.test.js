var chai = require('chai')
  , expect = chai.expect
  , helper = require('./helper')
  , nginuous = helper.nginuous
  , Gear = nginuous.Gear;


var myGear = new Gear({});

describe( 'Gear', function(){

  it('creates a new gear', function(){
    expect( myGear ).to.be.instanceOf( Gear );
  })

  describe( 'after app initializiation', function(){

    before( function(){
      this.app = nginuous();
    });

  });

});

