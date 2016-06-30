var fs = require('fs'),
    gulp = require('gulp'),
    clean = require('gulp-clean'),
    util = require('gulp-util'),
    imagemin = require('gulp-imagemin'),
    pngquant = require('imagemin-pngquant');
// util.log('log this');

var paths = {
  'imgSrc': './source/images/**/*',
  'imgDest': './source/images',
};

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

//Image Optimization
gulp.task('optimizeImages', function () {
    return gulp.src(paths.imgSrc)
        .pipe(imagemin({
            progressive: true,
            use: [pngquant()]
        }))
        .pipe(gulp.dest(paths.imgDest));
});

gulp.task('clean', function () {
  themes.forEach(function(theme) {
    return gulp.src(theme, {read: false})
      .pipe(clean());
  });
  return gulp.src('build', {read: false})
    .pipe(clean());
});

gulp.task('build', ['optimizeImages','clean']);
