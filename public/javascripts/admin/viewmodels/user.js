define(function(require) {

  var dataService = require('data_service')
    , ko = require('knockout')
    , i18n = require('i18next')
    , app = require('durandal/app')
    , nginiosHelper = require('nginios/helper')
    , moment = require('moment');

  var User = function User( data ){
    
    var self = this;

    this.setAttributes = function setAttributes( data ){

      data = data || { name: {}, last_login: {} };

      for( var i in data )
        this[i] = data[i];

      this.email = ko.observable( data.email || '');

      this.name = {
        last: ko.observable(data.name.last || ''),
        first: ko.observable(data.name.first || ''),
      };
      this.name.full = ko.computed( function(){ 
        return this.name.first()+' '+this.name.last(); 
      }, this);

      this.last_login_at = ko.computed( function(){
        return moment(this.last_login.at).fromNow();
      }, this);

      this.password = ko.observable();

    }

    this.setAttributes( data );

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

    // events
    this.editItem = function(item,e){
    }

    this.lockItem = function(item,e){
    }
    this.deleteItem = function(item, e){
    }

    this.createItem = function( item, e ){
      dataService.post( '/v1/users', ko.toJS(this), function( err ){
        if( err ){ return app.message(err); }
        app.message( i18n.t('user.created') );
      })
    }

    this.activate = function( id ){
      if( id === 'new' )
        return new User();
      dataService.getById('/v1/users', id, function( err, user_data ){
        self.setAttributes( user_data );
      });
    }

    this.attached = function( view ){
   
      // wait for animation to complete
      setTimeout(function(){
        $(view).find('.focus:first').focus();
      }, 500);
    }


  }

  return User;

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
