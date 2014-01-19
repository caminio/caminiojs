/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

var join        = require('path').join
  , fs          = require('fs')
  , _           = require('lodash')
  , i18next     = require('i18next');

module.exports = function I18nActions( caminio ){

  var translations = {}
    , paths = []
    , i18n;

  return {
    all: allTranslations,
    paths: paths,
    init: initTranslations,
    i18n: i18n
  }

  function allTranslations(){

    if( Object.keys(translations).length && caminio.environment !== 'development' )
      return translations;

    paths.forEach( function( i18nPath ){

      fs
        .readdirSync( i18nPath )
        .forEach(function(file) {
          var locale = file.replace('.js','');
          translations[locale] = translations[locale] || {};
          translations[locale]['caminio'] = translations[locale]['caminio'] || {};
          var localeData = require( join( i18nPath, file ) )( translations[locale]['caminio'] );
          //_.merge( translations[locals]['caminio'], localeData );
        });

    });

    return translations;

  }

  function initTranslations(){

    i18n = i18next.init({
      resStore: allTranslations(),
      lang: caminio.config.lang,
      fallbackLng: caminio.config.lang,
      ns: 'caminio',
      useCookie: false,
      detectLngFromHeaders: false
    });
  }

}