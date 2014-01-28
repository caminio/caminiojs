If you know a typical structure of a Ruby on Rails project, you might find this familiar.

    |
    |-- Gruntfile.js
    |-- package.json
    |
    |-- app
    |   |-- models
    |   |-- controllers
    |   |-- views
    |   |-- policies
    |   |-- middleware
    |
    |-- assets
    |   |-- javascripts
    |   |-- stylesheets
    |   |-- images
    |
    |-- config
    |   |-- routes.js
    |   |-- session.js
    |   |-- token.js
    |   |-- i18n
    |   |   |-- en.js
    |   |   |-- fr.js
    |   |   |-- de.js
    |   |   |-- ...
    |   |
    |   |-- errors
    |   |   |-- 404.js
    |   |   |-- 500.js
    |   |
    |   |-- environments
    |       |-- development.js
    |       |-- production.js
    |-- log
        |-- production.log

### MVC

caminio works Model-View-Controller oriented. If you are not familiar with that pattern, I recommend the [short but informative Wikipedia article](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller). That's pretty much how things work in caminio as well. 
