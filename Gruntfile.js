module.exports = function (grunt) {
    grunt.initConfig({
        'clean': {
            dist: ['dist'],
            debug: ['debug']
        },
        'copy': {
            debug: {
                files: [{
                    src: 'plugin/index.html',
                    dest: 'debug/index.html'
                },
                {
                    src: 'plugin/test.html',
                    dest: 'debug/test.html'
                },
                {
                    cwd: 'plugin',
                    expand: true,
                    src: '*.js',
                    dest: 'debug/'
                }]
            },
            dist: {
                files: [{
                    src: 'plugin/index.html',
                    dest: 'dist/index.html'
                },
                {
                    src: 'plugin/webtrends.js',
                    dest: 'dist/webtrends.js'
                }]
            }
        },
        'coffee': {
            compile: {
                files: [{
                    expand: true,
                    cwd: 'plugin/',
                    src: ['*.coffee'],
                    dest: 'debug/',
                    ext: '.js'
                }]
            }
        },
        'express': {
            dist: {
                options: {
                    script: 'server.js',
                    background: false
                }
            },
            debug: {
                options: {
                    script: 'debug_server.js',
                    background: true
                }
            }
        },
        'watch': {
            html : {
                files: ['plugin/*.html'],
                tasks: ['copy:debug'],
                options: {
                    livereload: true
                }
            },
            coffee : {
                files: ['plugin/*.coffee'],
                tasks: ['coffee'],
                options: {
                    livereload: true
                }
            }
        },
        uglify: {
            dist: {
                files: {
                    'dist/multiCurrency.js': ['debug/multiCurrency.js']
                }
            }
        },
        qunit: {
            all: {
                options: {
                    urls: [
                        'http://localhost:3000/test.html'
                    ]
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-express-server');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-qunit');
    grunt.registerTask('default', function () { console.log("Does nothing.."); });
    grunt.registerTask('dist', ['clean:debug', 'clean:dist', 'copy:debug', 'coffee', 'copy:dist', 'uglify:dist', 'express:dist']);
    grunt.registerTask('debug', ['clean:debug', 'copy:debug', 'coffee', 'express:debug', 'watch']);
    grunt.registerTask('test', ['clean:debug', 'copy:debug', 'coffee', 'express:debug', 'qunit:all']);
};