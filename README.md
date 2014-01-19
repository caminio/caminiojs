# caminio

Caminio is a cms framework wrapping expressjs/mongoose heavily inspired by RubyOnRails.

## features

* modularized [gears][] allowing to write reusable parts of a cms
  * the /api directory is read in every gear and includes views, controllers, middleware and models
* namespacing allows to write versioned apis
* autoRest, a feature inspired by sailsjs, generating a complete rest api automatically for a model
* keep control over middleware and policies through a highly adaptable middleware ecosystem
* asset minification
* themable GUI support. No need to start from scratch, just select the gears you want to use and start
  writing your own gear
  * GUI is driven by knockoutjs/durandal, a great combination


## installation

    npm install -g caminio

## usage

    caminio new myapp

This will create a new caminio application scaffold.

By default, you get 2 other plugins along with caminio:

* [caminio-auth][http://npmjs.org/package/caminio-auth] provides a User, a Group and a Domain model with authentication through passportjs
* [caminio-dashboard][http://npmjs.org/package/caminio-dashboard] provides a basic layout, the theming system and html files for the login system.

## The concept of Gears [gears] ##

Who knows RubyOnRails, can think of gears as of rails engines. A gear can carry a full /api tree with all features caminio provides. But caminio goes a step further. Basically, everything is considered a gear. Even the main application is considered a gear. If you take a look at your `index.js` file in the created app dirctory, you will find a line, invoking the gear:

    // ...
    // make this application a caminio gear:
    new Gear({ api: true });
    // ...