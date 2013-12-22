/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 * 
 */

module.exports = process.env.NGINUOUS_COV
? require('./lib-cov/nginuous')
: require('./lib/nginuous');
