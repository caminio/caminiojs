module.exports = process.env.NGINUOUS_COV
? require('./lib-cov/nginuous')
: require('./lib/nginuous');
