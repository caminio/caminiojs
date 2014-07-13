/* jshint node: true */
/* jshint expr: true */
'use strict';

var _         = require('lodash');

module.exports = exports = {
  
  create: function Router( path, controllerAction, filename, app ){
    var controller = controllerAction.split('#')[0];
    var action = controllerAction.split('#')[1];
    if( !_.contains( _.keys(app.controllers), controller ) )
      return app.logger.warn(filename, '\n\t', path, controllerAction, ' (Controller', controller, 'is unknown. Run `npm controllers` for a list of controller names)' );
    if( !app.controllers[controller].hasAction(action) )
      return app.logger.warn(filename, '\n\t', path, controllerAction, ' (Action', action, 'is unknown. Run `npm controllers` for a list of controller names)' );

    registerRoute( path, app.controllers[controller].actionsStore[action], app );

  }

};

/**
 * @private
 */
function registerRoute( path, actionDefs, app ){
  if( !path.match(/^get |^post |^put |^delete /) )
    return caminio.logger.error('failed to interpret path type:', path);
  var actionType = path.split(' ')[0].toLowerCase();
  app.expressApp[actionType].apply( app.expressApp, [path.split(' ')[1]].concat( actionDefs ) );
}

