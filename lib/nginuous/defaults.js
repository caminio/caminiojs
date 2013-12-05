var defaultOptions = {};

/**
 * the default port
 */
defaultOptions.port = 3000;

/**
 * log to console default: true
 */
defaultOptions.logConsole = true;

/**
 * log to file defualt: null
 */
defaultOptions.logfile = null;

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

  // read defaultOptions and fill opts
  for( var i in defaultOptions )
    opts[i] = defaultOptions[i];

  // and override those defaults if present
  for( var i in options )
    opts[i] = options[i];

  return opts;

}
