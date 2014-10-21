gulp = require 'gulp'
gTasks = require 'gulp-tasks'
nodeDev = require 'node-dev'

base = "#{__dirname}/dest"
bower = "#{__dirname}/bower_components"
dest =
  base: base
  templates: "#{base}/templates"
  vendor:
    js: "#{base}/vendor/js"
    css: "#{base}/vendor/css"

src =
  scripts:
    main: "#{__dirname}/client/scripts/main.coffee"
    watch: "#{__dirname}/client/scripts/**/*.coffee"
  templates:
    index: "#{__dirname}/client/index.jade"
    files: "#{__dirname}/client/templates/**/*.jade"
  styles:
    index: "#{__dirname}/client/styles/main.less"
    files: "#{__dirname}/client/styles/**/*.less"
  server: "#{__dirname}/server/index.coffee"
  vendor:
    js: [
      "#{bower}/angular/angular.min.js"
      "#{bower}/angular-route/angular-route.min.js"
      "#{bower}/angular-resource/angular-resource.min.js"
      "#{bower}/angular/angular.min.js.map"
      "#{bower}/angular-route/angular-route.min.js.map"
      "#{bower}/angular-resource/angular-resource.min.js.map"
      "#{bower}/leaflet/dist/leaflet.js"
      "#{bower}/leaflet-angular-icon/leaflet-angular-icon.min.js"
      "#{bower}/leaflet-grayscale/TileLayer.Grayscale.js"
    ]
    css: [
      "#{bower}/leaflet/dist/leaflet.css"
    ]

gulp.task 'build', [
  'build:scripts'
  'build:templates'
  'build:styles'
]

gulp.task 'build:scripts', ->
  gTasks.browserify.build src.scripts.main, dest.base
  gTasks.misc.copy src.vendor.js, dest.vendor.js

gulp.task 'build:templates', ->
  gTasks.jade.build src.templates.index, dest.base, true
  gTasks.jade.build src.templates.files, dest.templates, true

gulp.task 'build:styles', ->
  gTasks.less.build src.styles.index, dest.base
  gTasks.misc.copy src.vendor.css, dest.vendor.css

gulp.task 'server', ->
  gTasks.livereload.livereloadServer dest.base
  nodeDev [src.server]

gulp.task 'start', ['build', 'server']

gulp.task 'watch', ['build', 'server'], ->
  gulp.watch src.scripts.watch, ['build:scripts']
  gulp.watch [src.templates.index, src.templates.files], ['build:templates']
  gulp.watch [src.styles.index, src.styles.files], ['build:styles']

gulp.task 'default', ['watch']
