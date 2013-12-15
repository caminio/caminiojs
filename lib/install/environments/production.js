module.exports = function developmentEnvironment( config ){

  config.port = 3000;

  config.filestore.root = 'data';

  config.database.name = 'nginuo_us';
  
  return config;

};
