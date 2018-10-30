/*
 * really bad argparse
 *
 * -f is frontmatter
 * -c is content
 *
 * anything except -c actually gets ignored but whatever
 */
let option, inputFile;

if(process.argv[2].startsWith('-')) {
  option = process.argv[2][1];
  inputFile = process.argv[3];
}
else {
  inputFile = process.argv[2];
}

const fs = require('fs');
const matter = require('gray-matter');

fs.readFile(inputFile, 'utf-8', (err, fileContents) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  const grayMatterObj = matter(fileContents);

  if(typeof option === 'string' && option.toLowerCase() === 'c') {
    console.log(grayMatterObj.content);
  }
  else {
    console.log( JSON.stringify(grayMatterObj.data) );
  }
});
