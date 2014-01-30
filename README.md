[![Build Status](https://travis-ci.org/tastenwerk/caminio.png)](https://travis-ci.org/tastenwerk/caminio)

# caminio

Caminio is a cms framework wrapping expressjs/mongoose heavily inspired by RubyOnRails.

## features

* modularized [gears][] allowing to write reusable parts of a cms
  * the /api directory is read in every gear and includes views, controllers, middleware and models
* namespacing allows to write versioned apis
* autoRest, a feature inspired by sailsjs, generating a complete rest api automatically for a model
* keep control over middleware and policies through a highly adaptable middleware ecosystem
* asset minification
* themable GUI support (requires caminio-front) No need to start from scratch, just select the gears you want to use and start
  writing your own gear and embedd it in the GUI caminio provides.
  * GUI is driven by knockoutjs/durandal, a great team!


## installation

    $ npm install -g caminio-cli
    $ caminio project myproject
    $ cd myproject && npm install

starting caminio

    $ npm start

## Documentation

  [http://caminio.github.io/caminio](http://caminio.github.io/caminio)
  
## License

caminio is licensed under the MIT license. See LICENSE for more details.