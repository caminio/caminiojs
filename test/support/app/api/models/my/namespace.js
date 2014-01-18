module.exports = function( caminio, mongoose ){

  var Schema = mongoose.Schema({
    name: { type: String }
  });

  return Schema;

}