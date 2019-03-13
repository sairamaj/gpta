'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./ticket'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLETICKETCHECKIN
    console.log('table name:' + tableName)
    evt.getCheckInsAsync(tableName)
        .then(checkIns => {
            context.succeed(util.createResponse(200, checkIns))   
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
} 