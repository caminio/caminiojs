(function(){

  Handlebars.registerHelper( 'equal', function(lvalue, rvalue, options ){
    if( arguments.length < 3 )
      throw new Error("Handlebars Helper equal needs 2 parameters");
    if( this.get(lvalue) === rvalue )
      return options.fn(this);
    if(  typeof(options.inverse) === 'function' )
      return options.inverse(this);
  });

  Ember.Handlebars.helper('dynamicPartial', function(name, options) {
    return Ember.Handlebars.helpers.partial.apply(this, arguments);
  });

  Ember.Handlebars.registerHelper( 'tKey', function( key, options ){
    var attr = this.get(key);
    if( options.hash.prefix )
      attr = options.hash.prefix+'.'+attr;
    return Em.I18n.t(attr);
  });

})();
