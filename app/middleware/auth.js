/*
 * nginuous
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var auth = {};

var nginuous = require('../../');

/**
 * fails and render json response
 *
 * @param {Object} express response
 * @param {Number} status a valid http status number
 */
auth.fail = function fail( res, status, msg ){
  var json = { status: status };
  switch( status ){
    case 401:
      json.name = 'denied';
      json.msg = 'access denied';
      break;
    case 423:
      json.name = 'locked';
      json.msg = msg || 'the requested account is locked';
      break;
    case 500:
      json = msg;
      break;
  }
  res.json( status, { error: json } );
}

auth.authenticate = function authenticate( req, res, next ){
  auth.fail(res, 401);
  //next();
}

module.exports = auth;
