const fs = require('fs');
const matter = require('gray-matter');
const inputFile = process.argv[2];

fs.readFile(inputFile, 'utf-8', (err, fileContents) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  const grayMatterObj = matter(fileContents);
  console.log(grayMatterObj.content);
});
