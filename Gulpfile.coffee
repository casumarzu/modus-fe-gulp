gulp = require 'gulp'
$ = require('gulp-load-plugins')()
gulpsync = require("gulp-sync")(gulp)
gutil = require 'gulp-util'
gulpif = require 'gulp-if'
_ = require 'lodash'
chalk = require 'chalk'

jshint = require 'gulp-jshint'
remember = require 'gulp-remember'
concat = require "gulp-concat"


###
  configs
###

config =
  production: false

path =
  scripts: "app/scripts/**/*.coffee"
  css: "app/styles/**/*.sass"
  html: "app/html/**/*.jade"
  bower_components: "app/bower_components/**/*.*"
  images: "app/images/**/*.*"

destPath = '.tmp'

getProd = ->
  if config.production
    destPath = 'prod'
  else
    destPath = '.tmp'
  destPath

###
  end configs
###

livereload = require 'gulp-livereload'
connect = require 'gulp-connect'
modRewrite = require 'connect-modrewrite'
Proxy = require 'gulp-connect-proxy'

gulp.task 'server', ->
  destPath = getProd()
  connect.server
    root: "#{destPath}"
    livereload: true
    port: 8000

gulp.task "serverProxy", ->
  destPath = getProd()
  connect.server
    root: "#{destPath}"
    livereload: true
    port: 9000
    host: 'http://be-better.snpdev.ru'
    open:
      file: 'index.html'
      browser: 'chrome'
    middleware: (connect, opt) ->
      console.log 'serverProxy', opt
      opt.route = "/proxy"
      proxy = new Proxy(opt)
      [ proxy ]

gulp.task "reload", ->
  gulp.src path.scripts
    .pipe connect.reload()

browserSync = require('browser-sync').create()

gulp.task "browser-sync", ->
  browserSync.init
    open: true
    reloadDelay: 500
    reloadDebounce: 2000
    port: 9000
    proxy:
      target: "localhost:8000"

clean = require 'gulp-clean'
vinylPaths = require "vinyl-paths"
del = require "del"

gulp.task "clean", ->
  destPath = getProd()
  gulp.src("#{destPath}/*")
    .pipe vinylPaths(del)

coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'


browserify = require 'browserify'
watchify = require 'watchify'
reactify = require 'reactify'
source = require 'vinyl-source-stream'
coffeeReact = require "coffee-reactify"

browserifyShare = ->
  b = browserify(
    cache: {}
    packageCache: {}
    fullPaths: true
    entries: [ "./app/scripts/app.coffee" ]
    extensions: [ ".coffee", ".cjsx" ]
    debug: true
  )

  if watch
    b = watchify(b)
    b.on "update", ->
      bundleShare b
  b.transform coffeeReact
  b.add "./app/scripts/app.coffee"
  bundleShare b

bundleShare = (b) ->
  b.bundle()
  .pipe source "bundle.js"
  .pipe gulp.dest "#{destPath}/scripts"
  .pipe gulpif watch, connect.reload()

watch = undefined
gulp.task "browserify-nowatch", ->
  watch = false
  browserifyShare()

gulp.task "browserify", ->
  destPath = getProd()
  watch = true
  browserifyShare()

sass = require 'gulp-sass'
prefix = require 'gulp-autoprefixer'
cssmin = require 'gulp-cssmin'
sourcemaps = require 'gulp-sourcemaps'
concat = require 'gulp-concat'

gulp.task 'sass', ->
  destPath = getProd()
  gulp.src([ path.css ])
  .pipe($.sass(
    sourceComments: 'normal'
    includePaths: [ 'app/bower_components/' ]
    errLogToConsole: true))
  .pipe($.autoprefixer('last 7 version', 'ie 8', 'ie 9'))
  .pipe gulp.dest("#{destPath}/styles")
  # .pipe(concat("#{destPath}/main.css"))
  .pipe(sass().on('error', sass.logError))
  .pipe connect.reload()
  gulp.src "app/styles/sprite.png"
    .pipe gulp.dest "#{destPath}/styles"
    .pipe connect.reload()


jade = require 'gulp-jade'
minifyHTML = require 'gulp-minify-html'

gulp.task "html", ->
  destPath = getProd()
  gulp.src path.html
    .pipe jade()
    .pipe minifyHTML()
    .pipe gulp.dest "#{destPath}"
    .pipe connect.reload()

svgmin  = require 'gulp-svgmin'

gulp.task "svg", ->
  destPath = getProd()
  gulp.src "app/images/**/*.svg"
    .pipe svgmin()
    .pipe gulp.dest "#{destPath}/images"
    .pipe connect.reload()

gulp.task "copy", ->
  destPath = getProd()
  gulp.src "app/fonts/**/*"
    .pipe gulp.dest "#{destPath}/styles/fonts"
    .pipe connect.reload()
  gulp.src "app/images/**/*"
    .pipe gulp.dest "#{destPath}/images"
    .pipe connect.reload()
  gulp.src "app/styles/sprite.png"
    .pipe gulp.dest "#{destPath}/styles"
    .pipe connect.reload()
  gulp.src "app/bower_components/**/*"
    .pipe gulp.dest "#{destPath}/bower_components/"
    .pipe connect.reload()


gulp.task 'reload', ->
  gulp.src path.scripts
  .pipe connect.reload()

gulp.task "watch", ->
  destPath = getProd()
  gulp.watch path.scripts, ["reload"]
  gulp.watch path.css, ["sass"]
  gulp.watch path.html, ["html"]
  gulp.watch path.bower_components, ["clean", "copy"]

cssimage = require 'gulp-css-image'

gulp.task "cssimage", ->
  destPath = getProd()
  gulp.src("app/images/**/**").pipe(cssimage(
    css: false
    scss: true
    prefix:"img_"
    root:"../images"
    name: "_img.scss"
  )).pipe gulp.dest("./app/styles/")

spritesmith = require "gulp.spritesmith"

gulp.task "sprite", ->
  spriteData = gulp.src("app/images/sprites/*.png").pipe(spritesmith(
    imgName: "sprite.png"
    cssName: "_sprite.sass"
  ))
  spriteData.pipe gulp.dest 'app/styles'

gulp.task 'set-prod', -> config.production = true


storage = require('gulp-storage')(gulp)

gulp.storage.create 'ImagesJson', 'app/scripts/images.json'

gulp.task 'storageJSON',['addData'], ->
  # appName = @storage.get 'appName'

gulp.task 'addData', ->
  images = []
  _.each [1..120], (e)=>
    @storage.set 'image', "/images/image-#{e}.png"


shell = require 'gulp-shell'

gulp.task 'start', shell.task ['subl . && stree']


DEV_TASKS = do ->
  build = [
    'clean'
    'copy'
    'sass'
    'cssimage'
    'html'
    'sprite'
    'server'
    # 'serverProxy'
    'browser-sync'
    'browserify'
    'watch'
  ]
  build

PROD_TASKS = do ->
  build = [
    'set-prod'
    'clean'
    'copy'
    'sprite'
    'sass'
    'cssimage'
    'html'
    'server'
    # 'serverProxy'
    'browser-sync'
    'browserify-nowatch'
  ]
  build

gulp.task 'default', gulpsync.sync DEV_TASKS

gulp.task "prod", gulpsync.sync PROD_TASKS


###
todo запилить деплой
###
