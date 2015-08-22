require('coffee-script/register');
var gulpfile = require('./Gulpfile.coffee');
var gutil = require('gulp-util');

gutil.log('Using file', gutil.colors.magenta(gulpfile));
