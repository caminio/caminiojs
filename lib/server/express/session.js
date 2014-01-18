/*
 * camin.io
 *
 * @author quaqua <quaqua@tastenwerk.com>
 * @date 01/2014
 * @copyright TASTENWERK http://tastenwerk.com
 * @license MIT
 *
 */

module.exports = function( caminio, app ){

  if( !caminio.config.session.store )
    return;

  if( caminio.config.session.store.type === 'mongo' )
    app.use(express.session({
      secret: caminio.config.session.secret,
      store: new MongoStore({
        db: caminio.config.session.store.name,
        collection: 'sessions'
      })
    })
  );

}