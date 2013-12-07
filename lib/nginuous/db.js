/**
 * db - database connectivity
 */

var ConnectionHandler = require('./db/connection_handler');

var db = {};

db.ConnectionHandler = ConnectionHandler;

module.exports = db;
