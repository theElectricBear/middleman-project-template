var fs = require('fs');
var gulp = require('gulp');
var clean = require('gulp-clean');

var themes = JSON.parse(fs.readFileSync('./data/themes.json'));

gulp.task('clean', function () {
  themes.forEach(function(theme) {
    return gulp.src(theme.name, {read: false})
      .pipe(clean());
  });
  return gulp.src('build', {read: false})
    .pipe(clean());
});

gulp.task('build', ['clean']);
