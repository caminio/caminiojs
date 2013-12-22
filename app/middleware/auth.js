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
 * @param {Object} options
 *  * status: {Number} status code
 *  * state: {String} if request had a state present, this state must be returned
 *  * description: {String} optional human readable description
 *
 */
auth.fail = function fail( res, options ){
  var json = {};
  if( options.state )
    json.state = options.state;
  if( options.description )
    json.error_description = options.description;
  switch( options.status ){
    case 400:
      json.error = 'invalid_request'
    case 401:
      json.error = 'access_denied';
      break;
    case 423:
      json.error = 'client_id_locked';
      break;
    case 500:
      json.error = 'server_error';
      break;
  }
  res.json( status, json );
}

auth.authenticate = function authenticate( req, res, next ){
  auth.fail(res, 401);
  //next();
}

/**

  tries to authenticate given credentials

@method try
@param {String} accessToken
@param {String} refreshToken
@param {String} profile
@param {Function} done
**/
auth.try = function tryAuthentication(accessToken, refreshToken, profile, done){

  nginuous.orm.models.User.findOne({}, done );

}

module.exports = auth;
