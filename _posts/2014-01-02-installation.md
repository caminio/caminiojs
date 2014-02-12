caminio is 100% node javascript code. That means, you can use any of the major operating systems: Linux, Mac and Windows.

## Requirements

* NodeJS: [nodejs](http://nodejs.com)
* NPM: The node package manager (usually comes with nodejs, but in some cases like linux derivates, it is an independent package)
* Mongo NoSQL Database: [mongodb](http://mongodb.com)

## Installing caminio-cli

It is recommended to use the caminio command line interface to setup projects and get some helpers.

    $ npm install caminio-cli

With caminio-cli you can easily set up a new project:

    $ caminio project my-project
    $ cd my-project
    $ npm install

And you are ready to go. That's already the point where you can start the server

    $ npm start

This fires up the `grunt server` in development mode. Open your favorite browser and go to `http://localhost:4000`. To log in and create a user account, navigate to `http://localhost:4000/caminio`. If your database is empty, you will be prompted to create a new user.
