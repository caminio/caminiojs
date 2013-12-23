var config = {};

/**
 * the default port
 */
config.port = 3000;

/**
 * log to console default: true
 */
config.logConsole = true;

/**
 * log to file default: null
 */
config.logfile = null;

/**
 * the database object
 */
config.database = {};

/**
 * the type of database to use
 * possible: nedb (not supported yet), mongo
 */
config.database.type = 'mongo';

/**
 * database name or filename
 */
config.database.name = 'nginious_test';

/**
 * the filestore to store images and other
 * media content
 */
config.filestore = {};

/**
 * the type of the file store
 * possible: 'fs', aws (not supported yet)
 */
config.filestore.type = 'fs';

/**
 * the path to the file store
 */
config.filestore.path = '__cwd__/data';


/**
 * the session_secret
 */
config.session_secret = 'nginious secret please exchange';

/**
 * merges default settings with
 * given options and returns them
 *
 * @param [options] {Object} - the options for this instance
 * for values please see the defaults object itself
 *
 */
module.exports = function initDefaults( options ){

  var opts = {};

  // read config and fill opts
  for( var i in config )
    opts[i] = config[i];

  // and override those defaults if present
  for( var i in options )
    opts[i] = options[i];

  return opts;

}
