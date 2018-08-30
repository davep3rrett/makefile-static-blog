const fs = require('fs');
const ejs = require('ejs');
const pathToScan = process.argv[2];

fs.readdir(pathToScan, 'utf8', (err, files) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  ejs.renderFile('src/templates/index.ejs', {files: files, relativeCssPathPrefix: ''}, {}, (err, html) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    console.log(html);
  });
});

