define(function(require) {

  var ko = require('knockout')
    , notify = require('nginios/notify')
    , i18n = require('i18next');

  return function User( data ){
    
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
        if( this.last_login )
          return moment(this.last_login.at).fromNow();
        return i18n.t('never');
      }, this);

      this.role = ko.observable( data.role || 100);

      this.password = ko.observable();

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
