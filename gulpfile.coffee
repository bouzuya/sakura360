{Promise} = require 'es6-promise'
buildSite = require './src/_scripts/build-site'
del = require 'del'
deploy = require './src/_scripts/deploy'
getData = require './src/_scripts/get-data'
getFiles = require './src/_scripts/get-files'
gulp = require 'gulp'
gutil = require 'gulp-util'
moment = require 'moment'

gulp.task 'build', (done) ->
  run = require 'run-sequence'
  run.apply run, [
    'build-site'
    'copy-files'
    done
  ]

gulp.task 'build-site', ->
  getData()
  .then buildSite

gulp.task 'copy-files', ->
  srcDir = './src'
  files = getFiles srcDir
  gulp.src files, base: srcDir
    .pipe gulp.dest './public'

gulp.task 'clean', (done) ->
  del [
    './public'
  ], done

gulp.task 'deploy', ['clean'], ->
  message = moment().format() # commit message
  url = 'git@github.com:codeforkobe/sakura360.git' # repository url
  dst = 'gh-pages'
  dir = './public'
  name = 'circleci'
  email = 'circleci@example.com'
  build = ->
    getData()
    .then buildSite
  deploy { message, url, dst, dir, name, email, build }

gulp.task 'default', (done) ->
  run = require 'run-sequence'
  run.apply run, [
    'clean'
    'build'
    done
  ]
