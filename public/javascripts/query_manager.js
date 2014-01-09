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
    data[namespace] = JSON.parse(ko.toJSON( item ));

    var url = this.url
    if( data[namespace].id )
      url +='/'+data[namespace].id;

    this.ajaxOptions = {
      type: data[namespace].id ? 'put' : 'post',
      url: url,
      dataType: 'json',
      data: data
    }
    return this.exec();
  }

  QueryManager.prototype.remove = function remove( id ){

    this.ajaxOptions = {
      type: 'delete',
      url: this.url + '/' + id,
      dataType: 'json',
      data: { _csrf: CSRF }
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
          if( res.item ){
            if( self.model )
              return new self.model(res.item);
            return res.item;
          }
          if( res.items ){
            res.items.map( function(item){
              if( self.model )
                return new self.model(item);
              return item;
            });
            return res.items;
          }
          if( res.error ){
            notify( res.error, { error: true });
            return false;
          }
          return true;
        }
      })
    );
  }

  return QueryManager;

});
