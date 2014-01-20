module.exports = function( caminio, policies, middleware ){

  return {

    _before: {
      '*': policies.testAuthenticated,
      '*!(middleware_w_exception)': function( req, res, next ){ console.log('*-mid', req.actionName); req.text += ' middleware_w_exception '; next(); },
      'index,other': function( req, res, next ){ req.text += 'secondary'; next(); },
      'middleware,middleware_w_exception': [ middleware.special, middleware.special2 ]
    },

    'index': [
      function(req,res,next){ req.text += 'primary'; next() },
      function( req, res ){
        res.send( req.text );
      }
    ],

    'middleware': [
      middleware.testMiddleware,
      function( req, res ){
        res.send( req.text );
      }
    ],

    'middleware_w_exception': [
      middleware.testMiddleware,
      function( req, res ){
        res.send( req.text );
      }
    ]

  }

}