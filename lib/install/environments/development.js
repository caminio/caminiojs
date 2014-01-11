module.exports = function developmentEnvironment( config ){

  config.port = 3000;

  config.filestore.root = 'data';

  config.database.name = 'camin_io';

  config.superusers = [ 'manager@camin.io' ];

  config.available_plans = {
    ticketeer: ['caminio', 'caminio-ticketeer']
  }

  config.auth_token_timeout_min = 30;

  config.session_secret = '238293t8uoiauowaietuoawietuawet';

  config.remoteNamespace = 'caminio';

  return config;

};
