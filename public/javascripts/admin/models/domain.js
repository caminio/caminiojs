define(function(require) {

  var ko = require('knockout')
    , notify = require('nginios/notify')
    , UserModel = require('models/user')
    , i18n = require('i18next');

  return function User( data ){
    
    var self = this;

    this.setAttributes = function setAttributes( data ){

      data = data || {};

      for( var i in data )
        this[i] = data[i];

      this.name = ko.observable( data.name || '' );
      this.plan = ko.observable( data.plan || '' );

      this.owner = new UserModel(data.owner) || new UserModel({});

    }

    this.setAttributes( data );

    this.lockItem = function(item,e){
      notify( 'Not implemented yet' );
    }
    this.deleteItem = function(item, e){
      notify( 'Not implemented yet' );
    }


  }

});
