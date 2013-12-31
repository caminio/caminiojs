/*
 * nginios
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 * 
 */

module.exports = process.env.nginios_COV
? require('./lib-cov/nginios')
: require('./lib/nginios');
