/**
 * Butter Test autorest api
 *
 */
module.exports = function( caminio, mongoose ){

  var schema = new mongoose.Schema({
    name: { type: String },
    amount: { type: Number }
  });

  schema.trash = true;
  schema.publicAttributes = ['name','amount'];

  return schema;

};
