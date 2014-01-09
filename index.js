/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 * 
 */

module.exports = process.env.caminio_COV
? require('./lib-cov/caminio')
: require('./lib/caminio');
