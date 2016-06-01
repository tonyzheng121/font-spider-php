extend = require('extend')

module.exports = (grunt) ->
  require('time-grunt')(grunt);
  require('load-grunt-tasks')(grunt);

  # Pull remote php content to local html content
  host = 'http://192.168.222.180'
  pages = ['landing', 'feature', 'case', 'signup'];
  httpConfig = {}
  pages.forEach (page) ->
    httpConfig[page] =
      options:
        url:  "#{host}/site/#{page}"
        callback: (error, response, body) ->
          grunt.file.write("#{page}.html", body.replace(/\/build\/landing\/css/g, 'assets'))
  cssFileConfig =
    css:
      options:
        url: "#{host}/build/landing/css/app.css",
        callback: (error, response, body) ->
          grunt.file.write('assets/app.css', body.replace(/\/build\/landing\/fonts/g, '../fonts'));
  httpConfig = extend(httpConfig, cssFileConfig)

  grunt.initConfig
    'font-spider':
      options: {}
      main:
        src: ['./*.html', '!./index.html']
    clean:
      fonts: ['fonts/*']
      assets: ['*.html', '!index.html', 'assets', 'fonts/.font-spider']
    copy:
      main:
        expand: true
        cwd: 'fonts/.font-spider/'
        src: '*'
        dest: 'fonts'
        ext: '.ttf'
      fonts:
        expand: true
        cwd: 'fonts'
        src: '*'
        dest: 'latest'
    http: httpConfig

  grunt.registerTask('default', [
    'http',
    'font-spider',
    'copy:fonts',
    'clean:fonts',
    'copy:main'
    'clean:assets'
  ])
