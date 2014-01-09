/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var path = require('path')
  , fs = require('fs')
  , logger = require('./logger')
  , caminio = require('../../');

var translations = {};

module.exports.getTranslations = function getTranslations(app){

  if( Object.keys(translations).length && caminio.environment !== 'development' )
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
        translations[locale]['caminio'] = translations[locale]['caminio'] || {};
        var localeData = require( path.join( localePath, file ) );
        logger.info('i18n', 'found translation '+locale);
        for( var j in localeData ){
          recursiveFillChildren( translations[locale]['caminio'], j, localeData );
        }
      });

  }

  return translations;

}

function recursiveFillChildren( curData, key, localeData ){
  if( !(key in curData) ){
    curData[key] = localeData[key];
    return;
  }
  if( typeof(localeData[key]) === 'object' ){
    for( var i in localeData[key] )
      recursiveFillChildren( curData[key], i, localeData[key] )
    return;
  }
  curData[key] = localeData[key];
}
