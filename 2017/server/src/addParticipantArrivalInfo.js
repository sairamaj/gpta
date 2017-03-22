'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLEPARTCIPANTARRIVALINFO
    console.log('table name:' + tableName)
    var participantId = util.getPathParameter(event, "id")
    var arrivalStatus = util.getPathParameter(event, "status")
    evt.addParticipantArrivalInfoAsync(tableName, participantId, arrivalStatus )
        .then(status => {
            context.succeed(util.createResponse(200, status))
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
        
} 