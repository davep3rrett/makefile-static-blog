const fs = require('fs');
const path = require('path');
const ejs = require('ejs');
const matter = require('gray-matter');
const pathToScan = process.argv[2];

// to be populated with objects containing parsed front matter
const matterFiles = [];

// tmp var refer to current parsed front matter object
let grayMatterObj;

fs.readdir(pathToScan, 'utf8', (err, files) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }

  files.forEach((file) => {
    let filename = file.replace(/.md$/, '.html');
    let filepath = process.cwd() + '/src/posts/' + file;

    // parse the front matter and stick resulting object in our array from before
    grayMatterObj = matter( fs.readFileSync(filepath, 'utf-8') );
    grayMatterObj.data.filename = filename;
    matterFiles.push(grayMatterObj);
  });

  ejs.renderFile('src/templates/index.ejs', {files: matterFiles}, {}, (err, html) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    console.log(html);
  });
});

