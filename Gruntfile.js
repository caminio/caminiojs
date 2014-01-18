module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    mochaTest: {
      test: {
        options: {
          globals: ['should'],
          timeout: 3000,
          ignoreLeaks: false,
          ui: 'bdd',
          reporter: 'spec'
        },
        src: ['test/**/*.test.js']
      }
    },

    express: {
      default_option: {}
    }

  });

  // Load the plugin that provides the "uglify" task.
  //grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-express');

  grunt.registerTask('testAll', 'runs all tests', function(){
    grunt.config('mochaTest.test.src', ['test/**/*.test.js']);
    grunt.task.run('mochaTest');
  });

  grunt.registerTask('testUnit', 'runs only unit tests', function(){
    grunt.config('mochaTest.test.src', ['test/**/*.unit.test.js']);
    grunt.task.run('mochaTest');
  });

  grunt.registerTask('testApi', 'runs only api tests', function(){
    grunt.config('mochaTest.test.src', ['test/**/*.api.test.js']);
    grunt.task.run('express');
    grunt.task.run('mochaTest');
  });

  // Default task(s).
  grunt.registerTask('default', ['testAll']);

};