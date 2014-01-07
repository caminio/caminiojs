define(function(require) {

  var dataService = require('data_service')
    , ko = require('knockout')
    , i18n = require('i18next')
    , app = require('durandal/app')
    , nginiosHelper = require('nginios/helper')
    , DomainModel = require('models/user')
    , router = require('plugins/router')
    , domains = require('viewmodels/domains')
    , moment = require('moment');

  return function Domain( data ){
    
    this.item = new DomainModel( data );

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

    // methods
    this.i18n = i18n;

    this.createItem = function( form ){
      var self = this;
      var attrs = $(form).serializeArray();
      dataService.save( '/v1/domains', null, attrs, function( err, user ){
        if( err ){ return app.message(err); }
        if( user ){
          self.item.setAttributes( user );
          domains.items.push( self.item );
          app.message( i18n.t('user.created') );
          router.navigate('#domains');
        } else
          return app.message(i18n.t('user.creation_failed'));
      })
    }

    this.saveItem = function( form ){
      var self = this;
      var attrs = $(form).serializeArray();
      dataService.save( '/v1/domains', this.item.id, attrs, function( err, user ){
        if( err ){ return app.message(err); }
        if( user ){
          self.item.setAttributes( user );
          app.message( i18n.t('user.saved') );
          router.navigate('#domains');
        } else
          return app.message(i18n.t('user.creation_failed'));
      })
    
    }

    this.activate = function( id ){
      var self = this;
      self.item = null;
      if( id === 'new' )
        return self.item = new DomainModel();
      if( domains.items().length > 0 ){
        var match = ko.utils.arrayFirst(domains.items(), function(item) {
          if( id === item.id ){
            self.item = item;
          }
        });
      }
      if( !self.item )
        dataService.getById('/v1/domains', id, function( err, user_data ){
          self.item = new DomainModel( user_data );
        });
    }

    this.attached = function( view ){

      // wait for animation to complete
      setTimeout(function(){
        $(view).find('.focus:first').focus();
      }, 500);
    }


  }

  function getDomain(id){
    if( id === 'new' )
      return new Domain();
    dataService.get('/v1/domains/'+id)
    .find()
    .exec( function( err, user_data ){
      if( err ){ return console.log('error:', err); }
      return new Domain( user_data );
    });
  }

});
