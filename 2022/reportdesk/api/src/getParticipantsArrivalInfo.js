'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLEPARTCIPANTARRIVALINFO
    console.log('table name:' + tableName)
    evt.getParticipantArrivalInfoAsync(tableName)
        .then(data => {
            context.succeed(util.createResponse(200, data))
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
        
} 