'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLEPARTCIPANTARRIVALINFO
    console.log('table name:' + tableName)
    console.log('---------------')
    console.log(event.body)
    console.log('-------------------')
    var arrivalInfo = JSON.parse(event.body)
    console.log('arrivalInfo:' + JSON.stringify(arrivalInfo, null, 2))
    evt.addParticipantArrivalInfoAsync(tableName, arrivalInfo.id, arrivalInfo.status)
        .then(status => {
            context.succeed(util.createResponse(200, status))
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })

} 