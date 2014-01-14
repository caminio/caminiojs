define(function(require) {

  var dataService = require('data_service')
    , ko = require('knockout')
    , i18n = require('i18next')
    , app = require('durandal/app')
    , notify = require('caminio/notify')
    , caminioHelper = require('caminio/helper')
    , DomainModel = require('models/domain')
    , router = require('plugins/router')
    , domains = require('viewmodels/domains')
    , moment = require('moment');

  return function Domain( data ){
    
    this.item = new DomainModel( data );

    this.toggleCheckbox = caminioHelper.toggleCheckbox;

    this.genPwd = function genPwd(item, e){
      this.autoGenPwd = caminioHelper.generatePassword();
      $('input[name=domain\\[password\\]]').val( this.autoGenPwd );
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

    this.saveItem = function( form ){
      if( !checkPasswords() )
        return false;
      var self = this;
      var attrs = $(form).serializeArray();
      var newRecord = typeof(this.item.id) !== 'string';
      dataService.save( '/v1/domains', this.item.id, attrs, function( err, domain ){
        if( err ){ return notify(err); }
        if( domain ){
          self.item.setAttributes( domain );
          if( newRecord ){
            domains.items.push( self.item );
            notify( i18n.t('domain.created') );
          } else
            notify( i18n.t('domain.saved') );
          router.navigate('#domains');
        } else
          return notify(i18n.t('domain.creation_failed'));
      });
    
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
        dataService.getById('/v1/domains', id, function( err, domain_data ){
          self.item = new DomainModel( domain_data );
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
    .exec( function( err, domain_data ){
      if( err ){ return console.log('error:', err); }
      return new Domain( domain_data );
    });
  }

  function checkPasswords(){
    
    return true;

    if( this.owner().password() !== this.owner().password_confirmation() ){
      app.showMessage( $.i18n.t('user.passwords_missmatch') );
      return false;
    }
    if( this.owner().password().length < 6 ){
      app.showMessage( $.i18n.t('user.password_too_short') );
      return false;
    }
    return true;
  }

});
