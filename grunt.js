module.exports = function (grunt) {
  grunt.initConfig({
    jasmine: {
      specs: 'tmp/spec/javascripts/**/*_spec.js',
      amd: {
        lib: 'vendor/assets/javascripts/lib/require-2.1.4.min.js',
        main: 'tmp/spec/javascripts/spec_main.js'
      },
      helpers: [
        'spec/javascripts/helpers/**/*.js'
      ],
      runner_dir: 'tmp/spec/javascripts'
    }
  });

  // Register tasks.
  grunt.loadNpmTasks('grunt-jasmine-runner');

  // Default task.
  grunt.registerTask('default', 'jasmine');
};
