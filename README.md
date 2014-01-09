[![Build Status](https://travis-ci.org/tastenwerk/caminio.png)](https://travis-ci.org/tastenwerk/caminio)

# caminio

caminio is a modularized MVC framework inspired by Ruby on Rails.
It is build on top of the express js with build-in OAuth authentication 
and a simplified routing system.

## Features

* MVC framework
* Multi-Domain / Multi-Teancy system build in (but also works perfect as a single-domain instance)
* highly modularizable through [gears](#gear). Even it's core functionality is implemented as a gear
* Works similar to Rails Engines (can read in complete app/controller, app/models ... architecture from a plugged in gear)

## Dependencies

* expressjs
* mongoose
* passport

As well as low resource modules like momentjs, async, winston, commander

##requirements

* nodejs
* mongodb

## installation

create a caminio application:

    caminio new myapp

add caminio dependency to it's package.json by comitting

    npm install --save caminio

run the app the usual way

    node app

You should see something like:

    [caminio] running at port 3000


## <a name="gear"></a> Gear

a Gear is a logical unit or, if you want, a plugin. It is defined before
`caminio()` is called. The order does not matter.

### defining a new gear

    var Gear = caminio.Gear;
    var myGear = Gear.new();

When `caminio()` is called, the gear's base directory is parsed
for occurrence of `app` directory and `models`, `views` and `controllers` directories
inside. These structure works pretty much the same as rails' organizational strucutre
works.

So keep in mind, that Gear.new() has to be called from the directory relative to the ./app directory.

#### Gear Options

##### absolutePath

An absolute path to the directory containing the app structure. Default: ./app

##### name

An alternative name this gear should be registered with. Default: Filename of the file calling Gear.new(). 

## Model

Resource management is currently fixed to [mongoose](http://mongoosejs.com), but NeDB is also considered to
be supported one day.

a model is defined the usual way with the tiny difference of naming constraints. The
model's filenames are used to compute the model's name to register it to mongoose.

    // file: app/models/my.js
    //
    var caminio = require('caminio');

    var MySchema = caminio.orm.Schema({
      name: String,
      num: { type: Number, required: true }
    });

    module.exports = MySchema;

This will create a model / collection named 'My', resp. 'mys'. It can be accessed
directly via `var mongoose = require('mongoose'); mongoose.models.My` or the prefered way is to access
it via the mapper function `caminio.orm.models.My`


## Controller

    // file: app/controllers/my.js
    var caminio = require('../../')
      , Controller = caminio.Controller;
    
    var MyController = Controller.define( function( app ){
    
      this.get('/', function( req, res ){
        res.json(null);
      });
    
    });
    
    module.exports = DomainsController;

#### Parameters

##### app

The app Object which has been instantiated in the application's `app.js` file.

## Routing

Controllers can be used like in RubyOnRails now to put them in different routes. This is can be configured
via `config/routes.js` file, which should have been copied over when creating the project tree

    // file: config/routes.js


    var helper = require('../helper')
      , caminio = helper.caminio;
    
    caminio.router.add( '/my_namespace', 'my' );

alternatively, if the roue is going to have the same name as the controller:

    caminio.router.add( 'my' );

This would connect the my controller from above to the /my_namespace.


