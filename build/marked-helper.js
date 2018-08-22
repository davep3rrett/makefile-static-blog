const marked = require('marked');
const fs = require('fs');
const inputFile = process.argv[2];

marked.setOptions({
  gfm: true,
  tables: true,
  xhtml: true
});

fs.readFile(inputFile, 'utf8', (err, data) => {
  console.log( marked(data) );
});

