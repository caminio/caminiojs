define(function(require) {

  return new ServiceConnector();

  function ServiceConnector(){

    this.get = function get( url ){
      this.url = url;
      return this;
    }

    this.find = function find( query ){
      this.query = query || '';
      return this;
    }

    this.exec = function exec( callback ){
      $.getJSON( this.url + '?query=' + this.query )
      .done( function( json ){
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
