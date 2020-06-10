'use strict';

const { src, dest } = require('gulp');
const sass = require('gulp-sass');
const postcss = require('gulp-postcss');
const cssImport = require('postcss-import');
const cssnano = require('cssnano');

function css() {
  return src('./src/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(postcss([cssImport, cssnano()]))
    .pipe(dest('./dist'));
}

exports.css = css;
exports.default = css;
