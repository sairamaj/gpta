'use strict'
var util = require('./util')
var Promise = require('bluebird')
var ticket = Promise.promisifyAll(require('./ticket'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLE_NAME
    console.log('table name:' + tableName)
    console.log('---------------')
    console.log(event.body)
    console.log('-------------------')
    var ticketsInfo = JSON.parse(event.body)
    var totalprocessed = 0
    for(var ticketInfo of ticketsInfo){
        console.log('ticketInfo:' + JSON.stringify(ticketInfo, null, 2))
        ticket.addTicketAsync(tableName, ticketInfo)
            .then(status => {
                totalprocessed++
                if( totalprocessed == ticketsInfo.length){
                    context.succeed(util.createResponse(200, status))
                }
            })
            .catch(err => {
                totalprocessed++
                console.log('error in addticket')
                console.log(err)
                if( totalprocessed == ticketsInfo.length){
                    context.fail(util.createResponse(500, err))
                }
            })
    }

} 
