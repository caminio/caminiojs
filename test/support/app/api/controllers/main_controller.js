module.exports = function( caminio, policies, middleware ){

  return {

    _before: {
      '*': policies.testAuthenticated,
      'index,other': function( req, res, next ){ req.text += 'secondary'; next(); },
      'middleware': [ middleware.special, middleware.special2 ]
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
    ]

  }

}