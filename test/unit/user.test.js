var chai = require('chai')
  , expect = chai.expect
  , helper = require('../helper')
  , nginuous = helper.nginuous;


describe( 'User', function(){

  describe( 'properties', function(){

    before( function(){
      console.log('models: ', Object.keys(nginuous.models));
      this.user = new nginuous.models.User( helper.fixtures.user.plain );
    })
  
    it('has .name.first', function(){
      expect( this.user.name.first ).to.eq( helper.fixtures.user.plain.name.first );
    })

    it('has .name.last', function(){
      expect( this.user.name.last ).to.eq( helper.fixtures.user.plain.name.last );
    })

  });

});
