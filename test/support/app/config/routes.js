/*
 * routes
 *
 */

module.exports.routes = {
  
  '/': 'MainController#index',

  '/namespaced': 'My::NamespacedController#index',

  'resource /main': 'MainController',

  '/middleware': 'MainController#middleware'

}