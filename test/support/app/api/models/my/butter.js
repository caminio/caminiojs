/**
 * Butter Test autorest api
 *
 */
module.exports = function( caminio, mongoose ){

  var Schema = mongoose.Schema({
    name: { type: String },
    amount: { type: Number }
  });

  return Schema;

}