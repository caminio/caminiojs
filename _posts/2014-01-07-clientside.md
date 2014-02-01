requires `caminio-ui`

This chapter describes client-side related functions of caminio (provided by the caminio-ui gear). It might be better to outsource this documentation pages to an extra section. You can skip it, if you just want to use caminio as an api framework with now frontend.

## knockout and durandal

You can use any web-framework you like with caminio. But if you want to take advantage of the pre-configured functions, you should give those 2 kits a try. I assembled a `Gruntfile.js` which should help your gear to answer the right things when the main application's gear is checking for any `caminio-<name>` gears and asking them to run their own `grunt build`.

### jshint, js/css minification

The default Gruntfile has a couple of tasks to make it quite simple to reduce the amount of files presented to the browser in production mode. Have a look at `caminio-ui/api/views/admin/index.html.jade` to get an overview how this can distinguished and loaded.

## caminio-ds

knockout and durandal are great, but, they do not come with a data service. Breezejs is a great data service, but their documentation did not convince me and they seem to be a very windows-based community with visual-studio screenshots, and that's not neutral documentation style any more and driving me crazy when things are not working as described on Mac or Linux.

I really love the way ember-data works and I tried to took some ideas from that:

#### A note on AMD / requirejs

Be a friend of it or not. AMD increases development process as it structures dependencies, helps you dispatching your code in smaller files and keeps it more readable. People warning you of using AMD as it makes loads of network calls, just don't know the power of requirejs, actually: javascript. caminio (`grunt build`) zips all requirejs files together into one large file in production mode. You require one single file, require still recognises the dependencies.

### REST Adapter

The Rest Adapter gives you some kind of abstraction for doing server calls, instantiating json-responses into durandal models (in their terminology: modules).

    var RESTAdapter = require('ds/rest_adapter');

    var host1 = RESTAdapter.init( window.caminioHostname );

You can instantiate as many hosts as you like.

#### Defining a Model

    var Model = require('ds/model');

    // create a schema to define allowed attributes for this model
    var postSchema = { attributes: { name: ko.observable() } };

    // run the definition. This is typically run in an own file within the requirejs define(){} scope
    // and returns what we assign to the 'Post' var here.
    var Post = Model.define('Post', { adapter: host1 }, postSchema);

You can still use schemaless definitions without passing any schema to `Model.define`.


#### Creating a new model instance

    Post.create({name: 'test post'}, function( err, post ){
      if( err ){ alert('oh no, error'); }
      if( !post ){ alert('oh no, no post'); }
      // continue processing
    });

#### Finding a model

    Post.findOne({ id: '123456789012345678901234' }, function( err, post){
      if( err ){ alert('oh no, error'); }
      if( !post ){ alert('oh no, no post'); }
      // continue processing
    });

#### Saving changes to a model

    // ..
    // considering the schema definition above
    post.name('different name');
    post.save( function( err ){
      // error processing
      // continue processing
    })

#### Deleting a model

    // ..
    post.destroy( function( err ){
      // ..
    })
