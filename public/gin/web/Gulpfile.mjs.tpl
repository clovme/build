import gulp from 'gulp';
import rename from 'gulp-rename';
import browserSync from 'browser-sync';
import terser from 'gulp-terser';
import babel from 'gulp-babel';
import sourcemaps from 'gulp-sourcemaps';
import dartSass from 'sass';
import gulpSass from 'gulp-sass';
import postcss from 'gulp-postcss';
import autoprefixer from 'autoprefixer';
import cssnano from 'gulp-cssnano';
import {deleteAsync} from 'del';
import {createRequire} from 'module';
import clone from 'gulp-clone';
const require = createRequire(import.meta.url);
const revCollector = require('gulp-rev-collector');
const replace = require('gulp-replace');

const {src, dest, watch, series, parallel} = gulp;
const sass = gulpSass(dartSass);
const bs = browserSync.create();

const conf = {
    dest: 'dist',
    src: 'src',
    watch: {events: ['add', 'change', 'unlink'], queue: true},
};

// 删除文件
const cleanCss = () => deleteAsync([`${conf.dest}/assets/css`], {force: true});
const cleanJs = () => deleteAsync([`${conf.dest}/assets/js`], {force: true});
const cleanImg = () => deleteAsync([`${conf.dest}/assets/images`], {force: true});
const cleanHtml = () => deleteAsync([`${conf.dest}/*.html`], {force: true});
const cleanPlugins = () => deleteAsync([`${conf.dest}/assets/plugins`], {force: true});

// 正则
const rmspaceOpen = /\%\}\s+\{\{/g;
const rmspaceClose = /\}\}\s+\{\%/g;

// 处理 HTML
const html = series(cleanHtml, () =>
    src(`${conf.src}/*.html`)
        .pipe(revCollector({
            replaceReved: true,
            dirReplacements: {
                js: conf.dest,
                css: conf.dest,
            },
        }))
        .pipe(replace('.scss', '.min.css'))
        .pipe(replace('.js', '.min.js'))
        .pipe(replace(rmspaceOpen, '%}{{'))
        .pipe(replace(rmspaceClose, '}}{%'))
        .pipe(dest(conf.dest))
        .pipe(bs.stream())
);

// 编译SCSS → CSS
const css = series(cleanCss, () =>
    src(`${conf.src}/assets/css/**/*.scss`)
        .pipe(sourcemaps.init())
        .pipe(sass().on('error', sass.logError))
        .pipe(dest(`${conf.dest}/assets/css/`))
        .pipe(postcss([autoprefixer()]))
        .pipe(cssnano())
        .pipe(replace(/url\(([^)]+)\.scss\)/g, 'url($1.min.css)'))
        .pipe(rename({suffix: '.min'}))
        .pipe(sourcemaps.write('./maps', {addComment: false}))
        .pipe(dest(`${conf.dest}/assets/css/`))
        .pipe(bs.stream())
);

// 编译JS
const js = series(cleanJs, () => {
    const source = src(`${conf.src}/assets/js/**/*.js`).pipe(sourcemaps.init());
    const sourceClone = source.pipe(clone());

    // 原文件
    source.pipe(dest(`${conf.dest}/assets/js/`));

    // 压缩文件
    sourceClone
        .pipe(babel())
        .pipe(terser())
        .pipe(rename({ suffix: '.min' }))
        .pipe(sourcemaps.write('./maps', { addComment: false }))
        .pipe(dest(`${conf.dest}/assets/js/`))
        .pipe(bs.stream());

    return sourceClone;
});

// 复制图片
const images = series(cleanImg, () =>
    src(`${conf.src}/assets/images/**`, {encoding: false})
        .pipe(dest(`${conf.dest}/assets/images/`))
        .pipe(bs.stream())
);

// 复制插件文件
const plugins = series(cleanPlugins, () =>
    src(`${conf.src}/assets/plugins/**`, {encoding: false})
        .pipe(dest(`${conf.dest}/assets/plugins/`))
        .pipe(bs.stream())
);

// 监听文件变化
const watchFiles = (cb) => {
    bs.init({
        server: {
            baseDir: conf.dest,
            livereload: true,
        },
    });

    watch(`${conf.src}/assets/js/**/*.js`, conf.watch, js);
    watch(`${conf.src}/assets/css/**/*.scss`, conf.watch, css);
    watch(`${conf.src}/*.html`, conf.watch, html);
    watch(`${conf.src}/assets/plugins/**/*.*`, conf.watch, plugins);
    watch(
        [
            `${conf.src}/assets/images/**/*.png`,
            `${conf.src}/assets/images/**/*.jpg`,
            `${conf.src}/assets/images/**/*.jpeg`,
            `${conf.src}/assets/images/**/*.gif`,
        ],
        conf.watch,
        images
    );

    cb();
};

export default series(parallel(js, css, images, plugins), watchFiles);
