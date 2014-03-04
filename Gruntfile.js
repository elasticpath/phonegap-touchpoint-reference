'use strict';
var INTEGRATOR_URL = 'http://54.200.118.70:8080';
var SRC_FOLDER_NAME = 'ep-src';
var LIVERELOAD_PORT = 35729;
var SERVER_PORT = 9000;
var mountFolder = function (connect, dir) {
    return connect.static(require('path').resolve(dir));
};

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to match all subfolders:
// 'test/spec/**/*.js'
// templateFramework: 'lodash'

module.exports = function (grunt) {
    // show elapsed time at the end
    require('time-grunt')(grunt);
    // load all grunt tasks
    require('load-grunt-tasks')(grunt);

    // configurable paths
    var yeomanConfig = {
        app: 'app',
        dist: 'ep-mobile/dist'
    };

    function cordovaExec(cmd, platform) {
      return {
        cwd: 'ep-mobile',
        command: ['cordova', cmd, platform].join(' '),
        stdout: true,
        stderror: true
      };
    }

    grunt.initConfig({
        yeoman: yeomanConfig,
        clean: {
            dist: ['.tmp', '<%= yeoman.dist %>/*'],
            server: '.tmp'
        },
        copy: {
            cordovawww: {
                expand: true,
                cwd: SRC_FOLDER_NAME + '/public',
                nonull: true,
                src: '**',
                dest: 'ep-mobile/www'
            }
        },

        exec: {
          buildandroid  : cordovaExec('build', 'android'),
          buildios      : cordovaExec('build', 'ios'),
          deployandroid : cordovaExec('run', 'android'),
          deployios     : cordovaExec('run', 'ios'),
          emulateandroid: cordovaExec('emulate', 'android'),
          emulateios    : cordovaExec('emulate', 'ios')
        },

        rev: {
            dist: {
                files: {
                    src: [
                        '<%= yeoman.dist %>/scripts/{,*/}*.js',
                        '<%= yeoman.dist %>/styles/{,*/}*.css',
                        '<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}',
                        '/styles/fonts/{,*/}*.*',
                    ]
                }
            }
        }
    });

    grunt.registerTask('prep', function() {
      var epConfigFile = 'ep-mobile/www/ep.config.json',
        json = grunt.file.readJSON(epConfigFile);
      json.cortexApi.path = INTEGRATOR_URL + '/' + json.cortexApi.path ;
      grunt.file.write(epConfigFile, JSON.stringify(json));
    }) ;

    grunt.registerTask('dist', [
      'copy:cordovawww',
      'prep'
    ]);

    grunt.registerTask('build',function (platform){
      if (platform === 'android' || 'ios') {
        grunt.task.run([
          'exec:build'+platform
        ])
      }

    });

    grunt.registerTask('deploy', function (platform){
      if (platform === 'android' || 'ios') {
        grunt.task.run([
          'exec:deploy'+platform
        ])
      }
    });

    grunt.registerTask('emulate', function (platform){
      if (platform === 'android' || 'ios') {
        grunt.task.run([
          'exec:emulate'+platform
        ])
      }
    });

    grunt.registerTask('default', [
      'dist'
    ]);
};
