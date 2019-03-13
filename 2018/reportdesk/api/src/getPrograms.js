'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLE_NAME
    console.log('table name:' + tableName)
    var eventId = util.getPathParameter(event,"id")
    console.log('getPrograms ->' + eventId)
    evt.getProgramsAsync(tableName, eventId)
        .then(programs => {
            context.succeed(util.createResponse(200, programs))
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
} 