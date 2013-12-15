[![Build Status](https://travis-ci.org/tastenwerk/nginuous.png)](https://travis-ci.org/tastenwerk/nginuous)

# nginuous

an SaaS appliction which can be highly adapted and modulized.

nginuous is a multi-tenancy system (but it can also be used as
a single client application). It uses mongoose and passport to
store it's users (and the users' users), provides a web frontend,
notification and audit systems and with it's plugins, it can be
turned into an exciting CMS and CRM.

##requirements

* nodejs
* mongodb

## installation

create a plain node application the usual way

  express myapp

add nginuous dependency to it's package.json by comitting

  npm install --save nginuous

run the app the usual way

  node app

You should see something like:

  [nginuous] running at port 3000


### register a plugin

nginuous is just the core engine. It needs gears in order to serve functionality. Such a gear
can be registered in form of a plugin:

  var Gear = nginuous.Gear;
  var myGear = Gear.new();
