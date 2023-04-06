var qr = require('qr-image')
var fs = require('fs'), path = require('path')

var mkdirp = require('mkdirp');

mkdirp('images', function(err) { 
});

var baseUrl = 'http://dancedetails.s3-website-us-east-1.amazonaws.com/'
fs.readdir('../web', function(err, files){
    var htmlFiles = files
                    .filter( f=> f.endsWith('html'))
                    .filter( f => (f != 'error.html') && ( f != 'index.html') )
    htmlFiles.forEach( htmlFile => {
        var htmlUrl = "Abhilash Akula,abakula123@gmail.com,6SW64429E6173130K 3JR01788PK839950G 2R543605L2110010F 6XH68052019113833,4,0,160,1"
        var imageName =  path.join('images',path.basename(htmlFile, '.html') + '.png')
        console.log(imageName)
        console.log('generating: ' + htmlFile)
        var imageData = qr.imageSync(htmlUrl, { type: 'png' });
        fs.writeFileSync(imageName, imageData)        
    })
})

