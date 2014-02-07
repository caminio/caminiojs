module.exports = function( caminio, policies, middleware ){

  return {

    _before: {
      '*': policies.testAuthenticated,
      '*!(middleware_w_exception)': function( req, res, next ){ req.text += ' middleware_w_exception '; next(); },
      'index,other': function( req, res, next ){ req.text += 'secondary'; next(); },
      'middleware,middleware_w_exception': [ middleware.special, middleware.special2 ]
    },

    'index': [
      function(req,res,next){ req.text += 'primary'; next(); },
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
    ],

    'testSugars': [
      function( req, res ){
        res.send( typeof(policies.testSugars) );
      }
    ],

    'testChocolate': [
      function( req, res ){
        res.send( typeof(policies.testChocolate) );
      }
    ]


  };

};