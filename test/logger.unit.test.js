/* jslint node: true */
'use strict';

var vows          = require('vows'),
    assert        = require('assert'),
    fs            = require('fs'),
    Logger        = require('../lib/logger');

var testLogfile   = process.cwd()+'/test.log';

vows
  .describe('Logger')
  .addBatch({
    'default initialization': {
      topic: (new Logger()),

      'returns instance of Logger': function( logger ){
        assert.instanceOf( logger, Logger );
      },

      '@config.level: "debug"': function( logger ){
        assert.equal( logger.config.level, 'debug' );
      },

      '@config.to: "console"': function( logger ){
        assert.equal( logger.config.to, 'console' );
      }
    }
  })
  .addBatch({
    '#info': {
      topic: function(){
        fs.unlink( testLogfile );
        var logger = new Logger({ to: testLogfile });
        logger.info('test');
        this.callback();
      },
      'logs info to file': function(){
        assert.equal( fs.readFileSync(testLogfile, {encoding: 'utf8'}), 'info: test' );
      }
    }
  })
  .export(module);
