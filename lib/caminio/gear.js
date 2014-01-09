/*
 * caminio
 * (c) 2014 by TASTENWERK
 * license: GPLv3
 *
 */

var path = require('path')
  , gearRegistry = require('./gear_registry');

/**
a gear is a plugin for caminio. You can either write just
a simple library providing extra functionality or use it
like a rails engine and use relative the the file where new Gear()
is instantitiated.

In Version 1, the following directories will be parsed:
* app/models
* app/controllers
* app/middleware
* app/i18n

##Writing an application tab

To get an appliction tab in the application's menu, the app_paths key needs to be defined
when constructing the gear:

    new Gear({ 
      app_paths: { 
        'my_namespace': [ 
          { 
            name: 'My Contacts', 
            path: 'my_contacts', 
            icon: 'user', 
            require_manager: true, 
            position: 100 
          } 
        ] 
      } 
    });


### namespace and path

The namespace and path attributes need to match a namespace/controller key. In the example above
the controller would need to be in the directory app/controllers/my_namespace/ and would need to be named
my_contacts.js. This is a very specific thing of caminio.

caminio is expecting a route called my_namespace/my_contacts.html to return the new html view for this 
application.

### icon

a font-awesome icon key. caminio will automatically append the fa- string.

### require_manager

This tab will only be rendered, if the user is a domain manager

### require_superuser

This tab will only be rendered, if the user is in the config.superusers array

@class Gear
@constructor
@param {Object} options
@param {String} options.absolutePath [optional] the absolute path to be used to parse the app directory
@param {String} options.name [optional] an alternative name to be used for this gear. By default, the filename
of the gear will be used

**/

/**
The action to be called, when this tab is clicked. Default: path.html
@property action
@type String
**/

/**
The name of this gear. caminio will embrace it with a i18n.t translator. So You should add a translation key
matching: gears.paths.<name>
@property name
@type String
**/

/**
The Icon the navigation bar should prepend to the name of the app
@property name
@type String 
**/

/**
@property require_manager
@type Boolean
**/

/**
@property require_superuser
@type Boolean
**/

/**
@property position
@type Number
 **/

function Gear( options ){
  options = options || {};
  var caller = getCaller();
  /**
   * @property absolutePath
   * @type String
   * @default [dirname of the file where new Gear() is called]
   **/
  this.absolutePath = options.absolutePath || path.dirname( caller.filename );
  /**
   * @property name
   * @type String
   * @default [filename where new Gear() is called]
   **/
  this.name = options.name || path.basename( this.absolutePath );
  this.app_paths = options.app_paths;
  gearRegistry[this.name] = this;
}

Gear.prototype.toJSON = function toJSON(){
  return {
    name: this.name,
    app_paths: this.app_paths || [],
    hbs: this.hbs
  }
}

module.exports = Gear;

//
// this is a very clever hack from
// http://stackoverflow.com/questions/13227489
// to find out the absolute path
// to the caller
function getCaller() {
  var stack = getStack()

  // Remove superfluous function calls on stack
  stack.shift() // getCaller --> getStack
  stack.shift() // omfg --> getCaller

  // Return caller's caller
  return stack[1].receiver
}

function getStack() {
  // Save original Error.prepareStackTrace
  var origPrepareStackTrace = Error.prepareStackTrace

  // Override with function that just returns `stack`
  Error.prepareStackTrace = function (_, stack) {
    return stack;
  }

  // Create a new `Error`, which automatically gets `stack`
  var err = new Error()

  // Evaluate `err.stack`, which calls our new `Error.prepareStackTrace`
  var stack = err.stack

  // Restore original `Error.prepareStackTrace`
  Error.prepareStackTrace = origPrepareStackTrace

  // Remove superfluous function call on stack
  stack.shift() // getStack --> Error

  return stack;
}
