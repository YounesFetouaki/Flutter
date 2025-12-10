const fs = require('fs');
const pdf = require('pdf-extraction');

const pdfPath = process.argv[2];

let dataBuffer = fs.readFileSync(pdfPath);

pdf(dataBuffer).then(function (data) {
    console.log(data.text);
}).catch(function (error) {
    console.error(error);
});
