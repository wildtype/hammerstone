'use strict';

const { src, dest } = require('gulp');
const sass = require('gulp-sass');
const postcss = require('gulp-postcss');
const cssImport = require('postcss-import');
const cssnano = require('cssnano');

function css() {
  return src('./templates/css/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(postcss([cssImport, cssnano()]))
    .pipe(dest('./public/css'));
}

exports.css = css;
exports.default = css;
