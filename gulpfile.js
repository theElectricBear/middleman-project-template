var gulp = require('gulp');
var clean = require('gulp-clean');

gulp.task('default', function () {
  return gulp.src('app/tmp', {read: false})
    .pipe(clean());
});

gulp.task('build', ['clean']);
