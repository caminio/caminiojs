[![Build Status](https://travis-ci.org/caminio/caminio.png)](https://travis-ci.org/caminio/caminio)

# Motivation

caminio aims to provide a very small and modularized web framework covering the needs of a tiny
rest api provider up to a full featured and themed cms user interface.

This module just covers the loading and routing process.

# Getting started

    npm install -g caminio-cli

    caminio new my-rest-project

This will set up a minimalistic project where you can start from. Within the project:

    npm start

## Using the API restifier

You might want to add a database adapter:

    npm install --save caminio-db-sequelize

Now, you can start using the structure `app/models` and it will be associated with the current db
adapter. Note, it is not possible to mix db adapters.

As a last step you want to create a route for a model. Let's assume, we have a model called `Order`:

__config/routes.js__:
    module.exports = exports = {
      'restify /orders': 'Order'
    };

That's it!

After restarting the server, you can access your rest api with:

    curl http://localhost:4000/orders
    => []

# Under the hood

We took several ideas from rails which we were using for years and found very helpful. The initializer
architecture is one of such features.

## Initialization process

When calling `caminio()`, a new `Caminio` instance is created and passed back. After caminio has loaded
all native modules, all configurations are parsed (but not instantiated yet):

                      |
                      V
                   caminio
                      |
                      V
        process.cwd() / config / env.js
                      |
                      V
      process.cwd() / config / initializers / *
                      |
                      V
            app / {models,controllers,views}


# LICENSE

MIT
