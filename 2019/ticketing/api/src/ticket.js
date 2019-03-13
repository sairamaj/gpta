var aws = require('./awsFunc')
var colors = require('colors')
var debug=require('debug')('ticket')
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

function getTickets(tableName, callback) {
  aws.readDb(tableName, function (err, data) {
    if (err) {
      callback(err, null)
    } else {
      var tickets = []
      data.Items.forEach(function (ticket) {
        tickets.push(ticket)
      })
      callback(null, tickets)
    }
  })
}

function checkIn(tableName, checkinInfo, callback) {
  aws.writeDb(tableName, checkinInfo, function (err, status) {
    callback(err, status)
  })
}

function getCheckIns(tableName, callback) {
  aws.readDb(tableName, function (err, data) {
    if (err) {
      callback(err, null)
    } else {
      var checkIns = []
      data.Items.forEach(function (checkIn) {
        checkIns.push(checkIn)
      })
      callback(null, checkIns)
    }
  })
}

module.exports.addTicket = addTicket
module.exports.getTickets = getTickets
module.exports.checkIn = checkIn
module.exports.getCheckIns = getCheckIns