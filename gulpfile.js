var fs = require('fs');
var gulp = require('gulp');
var clean = require('gulp-clean');
var util = require('gulp-util');
// util.log('log this');

// http://stackoverflow.com/questions/10049557/reading-all-files-in-a-directory-store-them-in-objects-and-send-the-object#answer-10049704
var pages = [];
var filenames = fs.readdirSync('./data/pages');
filenames.forEach(function(filename) {
    var content = fs.readFileSync('./data/pages/' + filename, 'utf-8');
    pages.push(content);
});

// get unique themes in pages.json
var themes = [];
pages.forEach(function(page) {
    page = JSON.parse(page);
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
