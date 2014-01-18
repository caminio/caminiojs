module.exports = function( caminio, policies, stack ){

  return {

    _before: {
      '*': function( req, res, next ){ req.text = '*'; next(); },
      'index,other': function( req, res, next ){ req.text += 'secondary'; next(); }
    },

    'index': [
      function(req,res,next){ req.text += 'primary'; next() },
      function( req, res ){
        res.send( req.text );
      }
    ]

  }

}