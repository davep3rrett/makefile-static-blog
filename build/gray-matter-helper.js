const fs = require('fs');
const inputFile = process.argv[2];
const matter = require('gray-matter');

fs.readFile(inputFile, 'utf-8', (err, fileContents) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  const grayMatterObj = matter(fileContents);
  console.log( JSON.stringify(grayMatterObj.data) );
});
