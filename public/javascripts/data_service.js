define(function(require) {


  var cache = {};

  return new ServiceConnector();

  function ServiceConnector(){
    this.getById = function getById( url, id, callback ){
      if( cache[url] && cache[url][id] )
        return callback( null, cache[url][id] );
      this.get( url+'/'+id ).findOne().exec( callback );
    }

    this.get = function get( url ){
      this.url = url;
      return this;
    }

    this.save = function( url, id, attrs, callback ){
      if( id )
        url += '/'+id;
      $.ajax({
        url: url,
        data: attrs,
        type: id ? 'put' : 'post',
        dataType: 'json'
      })
      .done( function( res ){
        if( res.item )
          return callback( null, res.item );
        if( res.error )
          return callback( res.error );
        callback( 'invalid response. expected "item" or "error"');
      });
    }

    this.findOne = function findOne( query ){
      this.query = query || '';
      this.one = true;
      return this;
    }

    this.find = function find( query ){
      this.query = query || '';
      return this;
    }

    this.exec = function exec( callback ){
      var self = this;
      $.getJSON( this.url + '?query=' + this.query )
      .done( function( json ){
        if( self.one && json.item )
          return callback( null, json.item );
        if( json.items )
          return callback( null, json.items );
        callback( 'invalid server response. Expected "items" to be a key of response' );
      })
      .fail( function( status ){
        callback( status );
      });
    }
  }

});
