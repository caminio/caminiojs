var winston = require('winston');

var logger;

/**
 * initialize and setup the
 * logger
 *
 * this currently is just a wrapper to winston. But wrapping it gives
 * us the opportunity to replace it with something else or a lightweight
 * implementation
 *
 * @class logger
 *
 * @example
      logger.info('db', 'some text');
      -> <Timestamp> [caminio:db] some text
 **/
module.exports.init = function( options ){
  logger = new winston.Logger;

  if( options.logfile && fs.existsSync( path.dirname( options.logfile ) ) )
    logger.add( winston.transports.File, { filename: options.logfile, timestamp: true } )

  if( options.logConsole )
    logger.add( winston.transports.Console, { colorize: true, timestamp: true } );
}

/**
 * log now
 *
 * @param [level] {string} - the log level
 * @param [msg] {string} - the message to log
 * @param [subroutineCaller] {string} - an additional string to identify this log line a little better
 */
function log( level, subroutineCaller, msg ){
  if( typeof(msg) === 'undefined' ){
    msg = subroutineCaller;
    subroutineCaller = null;
  }
  msg = '[caminio' + (typeof(subroutineCaller) === 'string' ? '#'+subroutineCaller : '') + '] ' + msg;
  logger.log( level, msg );
}

module.exports.info = function( subroutineCaller, msg ){
  log('info', subroutineCaller, msg );
}

module.exports.warn = function( subroutineCaller, msg ){
  log('warn', subroutineCaller, msg );
}

module.exports.error = function( subroutineCaller, msg ){
  log('error', subroutineCaller, msg );
}

