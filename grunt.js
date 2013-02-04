module.exports = function(grunt) {
    grunt.initConfig({
        jasmine : {
            src : 'tmp/assets/javascripts/invalid/**/*.js',
            specs : 'tmp/spec/javascripts/**/*_spec.js',
            helpers : 'tmp/spec/javascripts/helpers/**/*.js',
            junit : {
                output : 'tmp/output/spec/javascripts/'
            }
        }
    });

    // Register tasks.
    grunt.loadNpmTasks('grunt-jasmine-runner');

    // Default task.
    grunt.registerTask('default', 'lint jasmine');
};
