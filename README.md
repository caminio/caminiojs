[![Build Status](https://travis-ci.org/tastenwerk/nginious.png)](https://travis-ci.org/tastenwerk/nginious)

# nginious

nginious is a modularized content management system atop of
express js with authentication and a predefined API system.

It serves multi-domain/multi-tenancy by default, but can also
serve as standalone system.

It's power is its modularity. Event nginious' core resources
are defined through [gears](#gear)
an SaaS appliction which can be highly adapted and modulized.

nginious is a multi-tenancy system (but it can also be used as
a single client application). It uses mongoose and passport to
store it's users (and the users' users), provides a web frontend,
notification and audit systems and with it's plugins, it can be
turned into an exciting CMS and CRM.

##requirements

* nodejs
* mongodb

## installation

create a nginious application:

    nginious new myapp

add nginious dependency to it's package.json by comitting

    npm install --save nginious

run the app the usual way

    node app

You should see something like:

    [nginious] running at port 3000


## <a name="gear"></a> Gear

a Gear is a logical unit or, if you want, a plugin. It is defined before
`nginious()` is called. The order does not matter.

### defining a new gear

    var Gear = nginious.Gear;
    var myGear = Gear.new();

When `nginious()` is called, the gear's base directory is parsed
for occurrence of `app` directory and `models`, `views` and `controllers` directories
inside. These structure works pretty much the same as rails' organizational strucutre
works.

## Model

Resource management is currently fixed to [mongoose](http://mongoosejs.com), but NeDB is also considered to
be supported one day.

a model is defined the usual way with the tiny difference of naming constraints. The
model's filenames are used to compute the model's name to register it to mongoose.

    // file: app/models/my.js
    //
    var nginious = require('nginious');

    var MySchema = nginious.orm.Schema({
      name: String,
      num: { type: Number, required: true }
    });

    module.exports = MySchema;

This will create a model / collection named 'My', resp. 'mys'. It can be accessed
directly via `var mongoose = require('mongoose'); mongoose.models.My` or the prefered way is to access
it via the mapper function `nginious.orm.models.My`


## Controller

    // file: app/controllers/my.js
    var nginious = require('../../')
      , Controller = nginious.Controller;
    
    var MyController = Controller.define( function(){
    
      this.get('/', function( req, res ){
        res.json(null);
      });
    
    });
    
    module.exports = DomainsController;

## Routing

Controllers can be used like in RubyOnRails now to put them in different routes. This is can be configured
via `config/routes.js` file, which should have been copied over when creating the project tree

    // file: config/routes.js


    var helper = require('../helper')
      , nginious = helper.nginious;
    
    nginious.router.add( '/my_namespace', 'my' );

alternatively, if the roue is going to have the same name as the controller:

    nginious.router.add( 'my' );

This would connect the my controller from above to the /my_namespace.


