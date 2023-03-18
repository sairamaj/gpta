'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./ticket'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLE_NAME
    console.log('table name:' + tableName)
    evt.getTicketsAsync(tableName)
        .then(tickets => {
            context.succeed(util.createResponse(200, tickets))   // all tickets
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
} 