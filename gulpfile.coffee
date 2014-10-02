gulp = require 'gulp'
gTasks = require 'gulp-tasks'
nodeDev = require 'node-dev'

dest = "#{__dirname}/dest"
src = 
  scripts: "#{__dirname}/client/scripts/main.coffee"
  templates:
    index: "#{__dirname}/client/index.jade"
    files: "#{__dirname}/client/template/**/*.jade"
  styles: "#{__dirname}/client/styles/main.less"
  server: "#{__dirname}/server/index.coffee"

gulp.task 'build', [
  'build:scripts'
  'build:templates'
  'build:styles'
]

gulp.task 'build:scripts', ->
  gTasks.browserify.build src.scripts, dest

gulp.task 'build:templates', ->  
  gTasks.jade.build src.templates.index, dest, true
  gTasks.jade.build src.templates.files, dest, true

gulp.task 'build:styles', ->
  gTasks.less.build src.styles, dest

gulp.task 'server', ->
  # gTasks.livereload.contentServer dest
  gTasks.livereload.livereloadServer dest
  nodeDev [src.server]

gulp.task 'start', ['build', 'server']

gulp.task 'watch', ['build', 'server'], ->
  gulp.watch src.scripts, ['build:scripts']
  gulp.watch [src.templates.index, src.templates.files], ['build:templates']
  gulp.watch src.styles, ['build:styles']

gulp.task 'default', ['watch']
