var fs = require('fs');

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    mochaTest: {
      test: {
        options: {
          globals: ['should'],
          timeout: 3000,
          bail: true,
          ignoreLeaks: false,
          ui: 'bdd',
          reporter: 'spec'
        },
        src: ['test/**/*.test.js']
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  //grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-mocha-test');

  grunt.registerTask('testAll', 'runs all tests', function(){
    grunt.task.run('clearLogs');
    grunt.config('mochaTest.test.src', ['test/**/*.test.js']);
    grunt.task.run('mochaTest');
  });

  grunt.registerTask('testUnit', 'runs only unit tests', function(){
    grunt.task.run('clearLogs');
    grunt.config('mochaTest.test.src', ['test/**/*.unit.test.js']);
    grunt.task.run('mochaTest');
  });

  grunt.registerTask('testModels', 'runs only model tests', function(){
    grunt.task.run('clearLogs');
    grunt.config('mochaTest.test.src', ['test/**/*model.unit.test.js']);
    grunt.task.run('mochaTest');
  });

  grunt.registerTask('testApi', 'runs only api tests', function(){
    grunt.task.run('clearLogs');
    grunt.config('mochaTest.test.src', ['test/**/*.api.test.js']);
    grunt.task.run('mochaTest');
  });

  grunt.registerTask('clearLogs', function(){
    if( fs.existsSync('test.log') )
      fs.unlinkSync('test.log');
  });
  
  // Default task(s).
  grunt.registerTask('default', ['testAll']);

};