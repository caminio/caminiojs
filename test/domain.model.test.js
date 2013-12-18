var async = require('async')
  , helper = require('./helper')
  , fixtures = helper.fixtures
  , expect = helper.chai.expect
  , nginuous = helper.nginuous;

describe( 'Domain', function(){

  describe( 'properties', function(){

    before( function(){
      this.domainAttrs = fixtures.domain.attributes();
      this.domain = fixtures.domain.build( this.domainAttrs );
    });

    it('is instance of Domain', function(){
      expect( this.domain ).to.be.instanceOf( nginuous.orm.models.Domain );
    });

    describe( 'has', function(){
  
      it('.name', function(){
        expect( this.domain.name ).to.eq( this.domainAttrs.name );
      });

      it('.description', function(){
        expect( this.domain.description ).to.eq( this.domainAttrs.description );
      });

    });

    describe( 'associates', function(){
    
      it('.messages (embedded)', function(){
        expect( this.domain.messages ).to.be.an('array');
      });

      it('.users (ref)', function(){
        expect( this.domain.users ).to.be.an('array');
      });

      it('.groups (ref)', function(){
        expect( this.domain.groups ).to.be.an('array');
      });

    });

    describe('requires', function(){

      beforeEach( function(){
        this.domain = fixtures.domain.build();
      });

      it('.name', function( done ){
        this.domain.name = null;
         this.domain.validate( 
           function( err ){
             expect( err ).to.exist;
             expect( err.errors.name.type ).to.eq('required');
             done();
           });
       });

      describe('format', function(){

        describe('.name', function(){

          beforeEach( function(){
            this.domain = fixtures.domain.build();
          });

          it('invalid domain', function(done){
            this.domain.name = 'test';
            this.domain.validate( 
              function( err ){
                expect( err ).to.exist;
                expect( err.errors.name.type ).to.eq('user defined');
                expect( err.errors.name.message ).to.eq('invalid domain name');
                done();
              });
          });

          it('valid domain', function(done){
            this.domain.name = 'test.example.com';
            this.domain.validate( 
              function( err ){
                console.log(err);
                expect( err ).to.not.exist;
                done();
              });
          });

        });

      });

    });


  });

  describe('methods', function(){

    describe('has many .users', function(){
      
      before( function( done ){
        var self = this;
        nginuous();
        async.parallel({
          domain: function( callback ){
            fixtures.domain.create( callback );
          },
          user: function( callback ){
            fixtures.user.create( callback );
          }
        }, function( err, results ){
          self.domain = results.domain;
          self.user = results.user;
          self.domain.users.push( self.user );
          done();
        });
      });

      it('has one domain membership', function(){
        expect(this.domain.users).to.have.length.of(1);
        expect(this.domain.users[0].toString()).to.eq(this.user.id.toString());
      });

    });

    describe('has many .groups', function(){
      
      before( function( done ){
        var self = this;
        nginuous();
        async.parallel({
          domain: function( callback ){
            fixtures.domain.create( callback );
          },
          group: function( callback ){
            fixtures.group.create( callback );
          }
        }, function( err, results ){
          self.domain = results.domain;
          self.group = results.group;
          self.domain.groups.push( self.group );
          done();
        });
      });

      it('has one domain membership', function(){
        expect(this.domain.groups).to.have.length.of(1);
        expect(this.domain.groups[0].toString()).to.eq(this.group.id.toString());
      });

    });

  });

});
