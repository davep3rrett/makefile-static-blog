const fs = require('fs');
const ejs = require('ejs');

let template, templateData;

if(process.argv[2]) {
  template = process.argv[2].toString();
}
else {
  process.exit(-1);
}

if(process.argv[3]) {
  templateData = JSON.parse(process.argv[3]);
}
else {
  templateData = {};
}

ejs.renderFile(template, templateData, {}, (err, html) => {
  if (err) {
    console.error(err);
    process.exit(-1);
  }
  console.log(html);
});

