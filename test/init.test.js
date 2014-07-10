/* jslint node: true */
'use strict';

var vows          = require('vows'),
    assert        = require('assert'),
    Caminio       = require('../index');

vows
  .describe('initialization')
  .addBatch({
    'default init': {
      topic: new Caminio(),

      'returns a caminio app instance': function( app ){
        assert.instanceOf( app, Caminio );
      },

      '@env: development': function( app ){
        assert.equal( app.env, 'development');
      },

      '@config: {}': function( app ){
        assert.isObject( app.config );
      },

      '@config.env: development': function( app ){
        assert.equal( app.config.env, 'development');
      } 
    }
  })
  .addBatch({
    '#start': {
      topic: (new Caminio()).start(),

      'server is running': function( app ){
        assert.equal( app.status, 'running' );
      }
    }
  })
  .export(module);
