$( function(){

  'use strict';

  Ember.Handlebars.registerBoundHelper('currentDate', function(format){
    return moment().format(format || 'LL');
  });

  Ember.Handlebars.registerBoundHelper('timeAgo', function( date ){
    var parsedDate = moment(date);
    return new Handlebars.SafeString('<time datetime="'+parsedDate.format()+'">'+parsedDate.fromNow()+'</time>');
  });

  Ember.Handlebars.registerBoundHelper('formatDate', function( date, options ){
    var formatter     = options.hash.format ? options.hash.format : 'LLL';
    var parsedDate    = date ? moment(date) : moment();
    var formattedDate = parsedDate.format(formatter);

    return new Handlebars.SafeString("<time datetime=" + date +">" + formattedDate + "</time>");
  });

  Ember.Handlebars.registerBoundHelper('smartDate', function( date ){
    var parsedDate    = date ? moment(date) : moment();
    var str;

    if( parsedDate.clone().subtract('d',7) >= moment().startOf('day').subtract('d',8) ){
      if( parsedDate.format('YYYY-MM-DD') === moment().format('YYYY-MM-DD') )
        str = Em.I18n.t('today') + ', ' + parsedDate.format('HH:mm') + ' ' + Em.I18n.t('o_clock');
      else if( parsedDate.format('YYYY-MM-DD') === moment().subtract('d',1).format('YYYY-MM-DD') )
        str = Em.I18n.t('yesterday') + ', ' + parsedDate.format('HH:mm') + ' ' + Em.I18n.t('o_clock');
      else
        str = parsedDate.format('dddd HH:mm') + ' ' + Em.I18n.t('o_clock');
    } else {
      str = parsedDate.format('DD. ');
      if( parsedDate.format('MM.YYYY') === moment().format('MM.YYYY') )
        str += parsedDate.format('MMMM');
      else
        str += parsedDate.format('MMMM');
      if( parsedDate.format('YYYY') !== moment().format('YYYY') )
        str += parsedDate.format('YYYY');
    }
    return new Handlebars.SafeString("<time title='" + parsedDate.format('LLLL') + "' datetime='" + parsedDate.format('LLLL') +"'>" + str + "</time>");
  });

  Ember.Handlebars.registerHelper('thisYear', function( date, options ){
    if( moment(this.get(date)).format('YYYY') === moment().format('YYYY') )
      return options.fn(this);
    return options.inverse(this);
  });

});
