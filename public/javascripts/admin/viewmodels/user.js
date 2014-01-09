define(function(require) {

  var dataService = require('data_service')
    , ko = require('knockout')
    , i18n = require('i18next')
    , notify = require('nginios/notify')
    , nginiosHelper = require('nginios/helper')
    , UserModel = require('models/user')
    , router = require('plugins/router')
    , users = require('viewmodels/users')
    , moment = require('moment');

  return function User( data ){
    
    this.item = new UserModel( data );

    this.toggleCheckbox = nginiosHelper.toggleCheckbox;

    this.genPwd = function genPwd(item, e){
      this.autoGenPwd = nginiosHelper.generatePassword();
      $('input[name=user\\[password\\]]').val( this.autoGenPwd );
      $('#pwd-suggestion-cleartext .result').text( this.autoGenPwd );
      $('#pwd-suggestion-cleartext').fadeIn();
      $('#suggest-pwd').removeClass('light').addClass('danger');
    }

    this.updateAutoGen = function updateAutoGen( item, e ){
      if( this.password !== this.autoGenPwd ){
        $('#pwd-suggestion-cleartext').fadeOut();
        $('#suggest-pwd').addClass('light').removeClass('danger');
      }
      return true;
    }

    this.updateRole = function updateRole( item, e ){
      this.item.role( this.item.role() <= 5 ? 100 : 1 );
      return true;
    }

    // methods
    this.i18n = i18n;

    this.createItem = function( form ){
      var self = this;
      var attrs = $(form).serializeArray();
      dataService.save( '/v1/users', null, attrs, function( err, user ){
        if( err ){ return notify(err); }
        if( user ){
          self.item.setAttributes( user );
          users.items.push( self.item );
          notify( i18n.t('user.created') );
          router.navigate('#users');
        } else
          return notify(i18n.t('user.creation_failed'));
      })
    }

    this.saveItem = function( form ){
      var self = this;
      var attrs = $(form).serializeArray();
      dataService.save( '/v1/users', this.item.id, attrs, function( err, user ){
        if( err ){ return notify(err); }
        if( user ){
          self.item.setAttributes( user );
          notify( i18n.t('user.saved') );
          router.navigate('#users');
        } else
          return notify(i18n.t('user.creation_failed'));
      })
    
    }

    this.activate = function( id ){
      var self = this;
      self.item = null;
      if( id === 'new' )
        return self.item = new UserModel();
      if( users.items().length > 0 ){
        var match = ko.utils.arrayFirst(users.items(), function(item) {
          if( id === item.id ){
            self.item = item;
          }
        });
      }
      if( !self.item )
        dataService.getById('/v1/users', id, function( err, user_data ){
          self.item = new UserModel( user_data );
        });
    }

    this.attached = function( view ){

      // wait for animation to complete
      setTimeout(function(){
        $(view).find('.focus:first').focus();
      }, 500);
    }


  }

  function getUser(id){
    if( id === 'new' )
      return new User();
    dataService.get('/v1/users/'+id)
    .find()
    .exec( function( err, user_data ){
      if( err ){ return console.log('error:', err); }
      return new User( user_data );
    });
  }

});
