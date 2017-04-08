'use strict';

var gulp = require('gulp');
var sass = require('gulp-sass');

gulp.task('sass', () => {
  return gulp.src('./src/assets/stylesheets/**/*.scss')
    .pipe(sass({ outputStyle: 'compressed' }).on('error', sass.logError))
    .pipe(gulp.dest('./public/assets/stylesheets'));
});

gulp.task('sass:watch', () => {
  gulp.watch('./src/assets/stylesheets/**/*.scss', ['sass']);
});
