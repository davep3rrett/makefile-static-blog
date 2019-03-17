const sass = require('node-sass');
const inputFile = process.argv[2];

sass.render({
  file: inputFile,
  sourceMap: false,
}, (err, result) => {
  if (err) {
    console.error(err);
    process.exit(1);
  }
  console.log(result.css.toString('utf8'));
});
