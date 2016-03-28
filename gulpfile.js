var fs = require('fs');
var gulp = require('gulp');
var clean = require('gulp-clean');
var util = require('gulp-util');
// util.log('log this');

var pages = JSON.parse(fs.readFileSync('./data/pages.json'));

// get unique themes in pages.json
var themes = [];
pages.forEach(function(page) {
    // if themes array does not contain page.theme
    if (page.theme && themes.indexOf(page.theme) == -1) {
        // add page.theme to array
        themes.push(page.theme);
    }
});

gulp.task('clean', function () {
  themes.forEach(function(theme) {
    return gulp.src(theme, {read: false})
      .pipe(clean());
  });
  return gulp.src('build', {read: false})
    .pipe(clean());
});

gulp.task('build', ['clean']);
