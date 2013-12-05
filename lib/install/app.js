/**
 * Module dependencies.
 */


var nginuous = require('nginuous');

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
