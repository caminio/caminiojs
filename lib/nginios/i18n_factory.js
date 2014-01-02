/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var path = require('path')
  , fs = require('fs')
  , logger = require('./logger')
  , nginios = require('../../');

var translations = {};

module.exports.getTranslations = function getTranslations(app){

  if( Object.keys(translations).length && nginios.environment !== 'development' )
    return translations;

  for( var i in app.gears ){
    var gear = app.gears[i];
    var localePath = path.join( gear.absolutePath, 'app', 'i18n' );
    if( !fs.existsSync(localePath) )
      continue;
    fs
      .readdirSync( localePath )
      .forEach(function(file) {
        var locale = file.replace('.js','');
        translations[locale] = translations[locale] || {};
        translations[locale]['nginios'] = translations[locale]['nginios'] || {};
        var localeData = require( path.join( localePath, file ) );
        logger.info('i18n', 'found translation '+locale);
        for( var i in localeData )
          translations[locale]['nginios'][i] = localeData[i];
      });
  
  }

  return translations;

}
