define(function(require) {

  var ko = require('knockout')
    , notify = require('nginios/notify')
    , $ = require('jquery');


  function QueryManager( options ){
    this.url = options.url;
    this.collection = options.collection;
    this.model = options.model;
  }

  QueryManager.prototype.findById = function findById( id ){

    if( this.collection ){
      var item = ko.utils.arrayFilter( this.collection, function( item ) {
        return item.id == id;
      });
      if( item && item[0] )
        return $.when( item[0] );
    }

    this.ajaxOptions = { 
      type: 'get',
      url: this.url + '/' + id,
      dataType: 'json'
    };

    return this.exec();

  }

  QueryManager.prototype.find = function find( query ){

    this.addQuery( query );

    this.ajaxOptions = { 
      type: 'get',
      url: this.url,
      dataType: 'json'
    };

    return this;

  }

  QueryManager.prototype.save = function save( namespace, item ){
    
    var data = { _csrf: CSRF };
    data[namespace] = ko.toJS( item );

    this.ajaxOptions = {
      type: item.id ? 'put' : 'post',
      url: this.url,
      dataType: 'json',
      data: ko.toJSON(data)
    }
    return this.exec();
  }

  QueryManager.prototype.addQuery = function( query ){
    this.query = this.query || {};
    for( var i in query )
      this.query[i] = query[i];
  };

  QueryManager.prototype.buildQuery = function(){
    this.ajaxOptions.data = this.query;
  }

  QueryManager.prototype.exec = function exec(){
    var self = this;
    if( !this.ajaxOptions.data )
      this.buildQuery();
    return $.when( 
      $.when( $.ajax( this.ajaxOptions ) ).then( function( res ){
        if( typeof(res) === 'object' ){
          if( res.item )
            return new self.model(res.item);
          if( res.items ){
            res.items.map( function(item){
              return new self.model(item);
            });
            return res.items;
          }
          app.notify( $.i18n.t('errors.unknown'), { error: true });
        }
      }) 
    );
  }

  return QueryManager;

});
