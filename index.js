/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 * 
 */

module.exports = process.env.nginious_COV
? require('./lib-cov/nginious')
: require('./lib/nginious');
