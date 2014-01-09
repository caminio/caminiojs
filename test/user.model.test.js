var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , caminio = helper.caminio;


describe( 'User', function(){

  describe( 'properties', function(){

    describe('has', function(){

      before( function(){
        this.user = fixtures.user.build();
      });

      it('.name.first', function(){
        expect( this.user.name.first ).to.eq( this.user.name.first );
      });

      it('.name.last', function(){
        expect( this.user.name.last ).to.eq( this.user.name.last );
      });

      it('.email', function(){
        expect( this.user.email ).to.eq( this.user.email );
      });

      it('.description', function(){
        expect( this.user.description ).to.eq( this.user.description );
      });

      it('.phone', function(){
        expect( this.user.phone ).to.eq( this.user.phone );
      });

      it('.encrypted_password', function(){
        expect( this.user.encrypted_password ).to.have.length(64);
      });

    });

    describe('associates', function(){

      before( function(){
        this.user = fixtures.user.build();
      });

      it('.messages (embedded)', function(){
        expect( this.user.messages ).to.be.an('array');
      });

      it('.groups (ref)', function(){
        expect( this.user.groups ).to.be.an('array');
      });

      it('.domains (ref)', function(){
        expect( this.user.groups ).to.be.an('array');
      });

    });

    describe('embedds', function(){

      before( function(){
        this.user = fixtures.user.build();
      });

      it('.preferences (nested)', function(){
        expect( this.user.preferences ).to.be.a('object');
      });

    });

    describe('returns', function(){

      before( function(){
        this.user = fixtures.user.build();
      });

      it('returns .name.full (virtual)', function(){
        expect( this.user.name.full ).to.eq( this.user.name.first+' '+this.user.name.last );
      });

      it('returns .password (virtual)', function(){
        expect( this.user.password ).to.eq( this.user.password );
      });

      it('returns number of unread_messages (virtual)', function(){
        expect( this.user.unread_messages ).to.eq(0);
      });

    });

    describe('requires', function(){

      beforeEach( function(){
        this.user = fixtures.user.build();
      });

      it('.email', function( done ){
        this.user.email = null;
        this.user.validate( 
          function( err ){
            expect( err ).to.exist;
            expect( err.errors.email.type ).to.eq('required');
            done();
          });
      });

      describe('format', function(){

        describe('.email', function(){

          beforeEach( function(){
            this.user = fixtures.user.build();
          });

          it('invalid if no @', function(done){
            this.user.email = 'test';
            this.user.validate( 
              function( err ){
                expect( err ).to.exist;
                expect( err.errors.email.type ).to.eq('user defined');
                expect( err.errors.email.message ).to.eq('invalid email address');
                done();
              });
          });

          it('valid', function(done){
            this.user.email = 'john@kings.com';
            this.user.validate( 
              function( err ){
                expect( err ).to.not.exist;
                done();
              });
          });

        });

      });

    });

  });

  describe('methods', function(){

    it('returns a salt for the user', function(){
      expect( this.user.generateSalt() ).to.have.length.above(9);
    });

    describe('authenticate', function(){

      it('valid password', function(){
        expect( this.user.authenticate( this.user.password ) ).to.be.true;
      });

      it('no password', function(){
        expect( this.user.authenticate('') ).not.to.be.true;
      });

      it('invalid password', function(){
        expect( this.user.authenticate('10326Test!') ).not.to.be.true;
      });

    });

    describe('group membership', function(){

      before( function( done ){
        var test = this;
        caminio();
        async.parallel({
          user: function( callback ){
                  fixtures.user.create( callback );
                },
          group: function( callback ){
                   fixtures.group.create( callback );
                 }
        }, function( err, results ){
          test.user = results.user;
          test.group = results.group;
          results.user.groups.push( results.group );
          done();
        });
      });

      it('has one group membership', function(){
        expect(this.user.groups).to.have.length.of(1);
        expect(this.user.groups[0].toString()).to.eq(this.group.id.toString());
      });

    });

    describe('domain membership', function(){

      before( function( done ){
        var test = this;
        caminio();
        async.parallel({
          user: function( callback ){
                  fixtures.user.create( callback );
                },
          domain: function( callback ){
                   fixtures.domain.create( callback );
                 }
        }, function( err, results ){
          test.user = results.user;
          test.domain = results.domain;
          results.domain.addUser( results.user, false, done );
        });
      });

      it('has one domain membership', function(){
        expect(this.user.domains).to.have.length.of(1);
        expect(this.user.domains[0].toString()).to.eq(this.domain.id.toString());
      });

    });


  });

});
