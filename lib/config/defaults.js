/* jslint node: true */
'use strict';

var defaults = module.exports;

defaults.env = process.env.NODE_ENV || 'development';

/**
 * @property log
 * @type Object
 */
defaults.log = {};

/**
 * @property log.level
 * @type String
 * @default 'debug'
 */
defaults.log.level = 'debug';

/**
 * @property log.to
 * @type String
 * @default 'console'
 *
 * possible values are:
 * * 'console' - logs to console
 * * '<absolute_path> - logs to absolute path
 */
defaults.log.to = 'console';

/**
 * @property port
 * @type Number
 * @default 4000
 */
defaults.port = 4000;
