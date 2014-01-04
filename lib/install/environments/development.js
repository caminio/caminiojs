module.exports = function developmentEnvironment( config ){

  config.port = 3000;

  config.filestore.root = 'data';

  config.database.name = 'nginios_com';

  config.superusers = [ 'manager@nginios.com' ];

  config.auth_token_timeout_min = 30;

  config.session_secret = '238293t8uoiauowaietuoawietuawet';

  return config;

};
