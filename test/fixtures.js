var fs = require('fs')
  , path = require('path');

var fixtures = {};

fs
  .readdirSync(__dirname+'/fixtures')
  .filter(function(file) {
    return file.indexOf('.fixture.js') > 0
  })
  .forEach(function(file) {
    fixtures[ file.replace('.fixture.js','') ] = require( path.join( __dirname, 'fixtures', file ) );
  });

module.exports = fixtures;
