var caminio = require('../../../lib/caminio')
  , Gear = require('../../../lib/gear');

caminio.gears.register( new Gear({ api: true }) );

caminio.init({ config: { root: __dirname }});