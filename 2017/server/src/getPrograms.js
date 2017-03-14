'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

exports.handler = function (event, context, callback) {
    evt.getProgramsAsync('Program', "a4a1acfe-d434-48cc-ae08-480e0949c98d")
        .then(programs => {
            context.succeed(util.createResponse(200, programs))
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
} 