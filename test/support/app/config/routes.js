/*
 * routes
 *
 */

module.exports.routes = {
  
  '/': 'MainController#index',

  '/namespaced': 'MyNamespacedController#index',

  'resource /main': 'MainController',

  '/middleware': 'MainController#middleware'

}