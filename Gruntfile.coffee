_ = require 'lodash'

module.exports = (grunt) ->

  # Includes --------------------------------------------
  grunt.loadNpmTasks('grunt-spritesmith')
  grunt.loadNpmTasks('grunt-svgstore')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-compass')
  grunt.loadNpmTasks('grunt-contrib-copy')


  # Config ----------------------------------------------
  config =
    src: "src"
    dest: "build"

  grunt.initConfig _.extend config,

    sprite:
      common:
        src       : '<%= src  %>/images/sprites/common/*.png'
        destImg   : '<%= dest %>/images/sprites/common.png'
        destCSS   : '<%= dest %>/css/sprites/common.scss'
        imgPath   : '../../<%= dest %>/images/sprites/common.png'
        cssFormat : 'css'

    svgstore:
      default:
        options:
          includedemo: true
          cleanupdefs: true
          inheritviewbox: true
        files:
          '<%= dest %>/images/svg-deps.svg': ['<%= src %>/images/svg/*.svg'],

    compass:
      css:
        options:
          sassDir       : '<%= src %>/css'
          cssDir        : '<%= dest %>/css'
          importPath    : [ 'build/css' ]
            .concat( grunt.file.expand({}, 'bower_components/**/*') )

    copy:
      cssAsScss:
        files: [
          {
            expand: true,
            cwd: 'bower_components',
            src: ['**/*.css', '!**/*.min.css'],
            dest: 'bower_components',
            filter: 'isFile',
            ext: ".scss"
          }
        ]
      images:
        files: [{
            expand: true
            cwd: '<%= src %>/images'
            src: ['**/*.png', '**/*.jpg']
            dest: '<%= dest %>/images'
          }
        ]
      svg:
        files: [{
            expand: true
            cwd: '<%= src %>/images/svg'
            src: ['*.svg']
            dest: '<%= dest %>/images/svg'
        }]

    jade:
      compile:
        options:
          data:
            debug: true
          pretty: true
        files:
          "<%= dest %>/index.html": ["<%= src %>/index.jade"]

    watch:
      options:
        spawn: false
      svg:
        files: ['<%= src %>/images/svg/*.svg']
        tasks: ['svg']
      images:
        files: ['<%= src %>/images/*.png']
        tasks: ['images']
      jade:
        files: ['<%= src %>/*.jade']
        tasks: ['jade']
      compass:
        files: ['<%= src %>/css/**/*.scss']
        tasks: ['css']

  # Tasks ------------------------------------------------
  grunt.registerTask 'css', ['copy:cssAsScss', 'compass:css']
  grunt.registerTask 'images', ['copy:images', 'sprite']
  grunt.registerTask 'svg', ['copy:svg', 'svgstore']

  grunt.registerTask 'build', ['images', 'svg', 'css',  'jade']

  # Default ----------------------------------------------
  grunt.registerTask 'default', ['build']
