const { src, dest } = require('gulp');

src('./*.html').pipe(dest('./dist/company-report'));

