'use strict'
var util = require('./util')
var Promise = require('bluebird')
var ticket = Promise.promisifyAll(require('./ticket'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLETICKETCHECKIN
    console.log('table name:' + tableName)
    console.log('---------------')
    console.log(event.body)
    console.log('-------------------')
    var checkinInfo = JSON.parse(event.body)
    console.log('arrivalInfo:' + JSON.stringify(checkinInfo, null, 2))
    ticket.checkInAsync(tableName, checkinInfo)
        .then(status => {
            context.succeed(util.createResponse(200, status))
        })
        .catch(err => {
            console.log('error in checkin')
            console.log(err)
            context.fail(util.createResponse(500, err))
        })

} 
