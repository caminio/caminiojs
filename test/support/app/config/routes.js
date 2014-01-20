/*
 * routes
 *
 */

module.exports.routes = {
  
  '/': 'MainController#index',

  '/namespaced': 'My::NamespacedController#index',

  'resource /main': 'MainController',

  '/middleware': 'MainController#middleware',

  '/middleware_w_exception': 'MainController#middleware_w_exception'

}