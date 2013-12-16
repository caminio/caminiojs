var chai = require('chai')
  , expect = chai.expect
  , helper = require('./helper')
  , nginuous = helper.nginuous;


describe( 'User', function(){

  describe( 'properties', function(){

    before( function(){
      this.user = new nginuous.models.User( helper.fixtures.user.plain );
    })
  
    it('has .name.first', function(){
      expect( this.user.name.first ).to.eq( helper.fixtures.user.plain.name.first );
    });

    it('has .name.last', function(){
      expect( this.user.name.last ).to.eq( helper.fixtures.user.plain.name.last );
    });

    it('has .email', function(){
      expect( this.user.email ).to.eq( helper.fixtures.user.plain.email );
    });

    it('has .description', function(){
      expect( this.user.description ).to.eq( helper.fixtures.user.plain.description );
    });

    it('has .phone', function(){
      expect( this.user.phone ).to.eq( helper.fixtures.user.plain.phone );
    });

    it('has .encryptedPassword', function(){
      expect( this.user.encryptedPassword ).to.have.length(64);
    });

    it('has many .messages (embedded)', function(){
      expect( this.user.messages ).to.be.an('array');
    });

    it('has many .loginLog (embedded)', function(){
      expect( this.user.loginLog ).to.be.an('array');
    });

    it('has many .groups (ref)', function(){
      expect( this.user.groups ).to.be.an('array');
    });

    it('has many .domains (ref)', function(){
      expect( this.user.groups ).to.be.an('array');
    });

    it('has .preferences (nested)', function(){
      expect( this.user.preferences ).to.be.a('object');
    });

    it('returns .name.full (virtual)', function(){
      expect( this.user.name.full ).to.eq( helper.fixtures.user.plain.name.first+' '+helper.fixtures.user.plain.name.last );
    });

    it('returns .password (virtual)', function(){
      expect( this.user.password ).to.eq( helper.fixtures.user.plain.password );
    });

    it('returns number of unreadMessages (virtual)', function(){
      expect( this.user.unreadMessages ).to.eq(0);
    });

  });

  describe('methods', function(){
    
    it('returns a salt for the user', function(){
      expect( this.user.generateSalt() ).to.have.length.above(9);
    });

    describe('authenticate', function(){

      it('valid password', function(){
        expect( this.user.authenticate( helper.fixtures.user.plain.password ) ).to.be.true;
      });

      it('no password', function(){
        expect( this.user.authenticate('') ).not.to.be.true;
      });

      it('invalid password', function(){
        expect( this.user.authenticate('10326Test!') ).not.to.be.true;
      });

    });

  });

});
