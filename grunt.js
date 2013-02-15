module.exports = function (grunt) {
  grunt.initConfig({
    jasmine: {
      specs: 'tmp/spec/javascripts/**/*_spec.js',
      helpers: [
        'spec/javascripts/helpers/**/*.js',
        'tmp/spec/javascripts/helpers/**/*.js'
      ],
      amd: {
        lib: 'vendor/assets/javascripts/lib/require-2.1.4.min.js',
        main: 'tmp/spec/javascripts/spec_main.js'
      },
      'runner-dir': 'tmp/spec/javascripts'
    }
  });

  // Register tasks.
  grunt.loadNpmTasks('grunt-jasmine-runner');

  // Default task.
  grunt.registerTask('default', 'jasmine');
};
