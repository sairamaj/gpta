var qr = require('qr-image')
var fs = require('fs'), path = require('path')

if (process.argv.length <= 2) {
    console.error('Ticket csv file is required (node gen_qrcode_ticket.js test.csv)');
    process.exit(1);
}

var csvFile = process.argv[2]

var mkdirp = require('mkdirp');
const { cwd } = require('process');

mkdirp('../output/images', function (err) {
});

function generate(info){
    var parts = info.split(',')
    var email = parts[1]

    var imageName =  path.join('../output/images',email + '.png')
    var imageData = qr.imageSync(info, { type: 'png' });
    fs.writeFileSync(imageName, imageData)   
}

console.log(`processing: ${csvFile}`)
line = fs.readFileSync(csvFile,{encoding: 'utf-8'})
// split and skip first 2 lines as they are header lines
var tickets = line.split('\r\n').slice(2)

tickets.forEach(t => {
    generate(t)
});