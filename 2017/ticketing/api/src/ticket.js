var aws = require('./awsFunc')
var colors = require('colors')

function addTicket(tableName, ticketInfo, callback) {
    debug('inserting' + JSON.stringify(ticketInfo))
    aws.writeDb(tableName, ticketInfo, function (err, status) {
        if (err) {
            var msg = 'err inserrting:' + JSON.stringify(ticketInfo)
            console.log(msg.red)
        }
        callback(err, status)
    })
}

module.exports.addTicket = addTicket
