/*
 * nginious
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var moment = require('moment')
  , nginious = require('../../');


var auth = {};

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
  res.json( options.status, json );
}

auth.authenticate = function authenticate( req, res, next ){
  auth.fail(res, 401);
  //next();
}

auth.ipAddress = function ipAddress( req ){
  return req.headers['x-forwarded-for'] || req.connection.remoteAddress;
}

auth.loadClient = function loadClient( req, res, next ){
  if( req.param('client_id') && req.param('client_secret') ){
    nginious.orm.models.Client.findOne({ 
      _id: req.param('client_id'),
      secret: req.param('client_secret')
    }).exec( function( err, client ){
      if( err ){ return next(err); }
      if( client )
        res.locals.client = client;
      next();
    });
  } else {
    auth.fail( res, { status: 400, description: 'invalid_request' });
  }
}

auth.maintainRequestTokens = function maintainRequestTokens( req, res, next ){
  nginious.orm.models.RequestToken.remove({ 
    '$lte': { created_at: moment().subtract('m', nginious.app.config.auth_token_timeout_min).toDate() }
  }, next );
}

auth.maintainAccessTokens = function maintainAccessTokens( req, res, next ){
  nginious.orm.models.AccessToken.remove({ 
    '$lte': { expires_at: (new Date()) }
  }, next );
}

auth.loadRequestToken = function loadRequestToken( req, res, next ){
  nginious.orm.models.RequestToken.findOne({
    token: req.param('code'),
    redirect_uri: req.param('redirect_uri')
  }, function( err, requestToken ){
    if( err ){ return auth.fail( res, { status: 500, description: 'server_error' }); }
    if( !requestToken ){ return auth.fail( res, { status: 401, description: 'access_denied' }); }
    res.locals.requestToken = requestToken;
    next();
  });
}

auth.token = function token( req, res, next ){
  if( !req.headers['authorization'] )
    return auth.fail( res, { status: 400, description: 'invalid_request' } );

  var bearer = req.headers['authorization'].replace('Bearer ','')
  nginious.orm.models.AccessToken.findOne({
    token: bearer
  }).populate('user').exec( function( err, token ){
    if( err ){ return auth.fail( res, { status: 500, description: err }); }
    if( !token ){ return auth.fail( res, { status: 401, description: 'access_deneid' }); }
    res.locals.user = token.user;
    next();
  });
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

  nginious.orm.models.User.findOne({}, done );

}

module.exports = auth;
