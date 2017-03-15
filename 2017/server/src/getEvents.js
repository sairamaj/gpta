'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLE_NAME
    console.log('table name:' + tableName)
    evt.getEventsAsync(tableName)
        .then(events => {
            var eventId = util.getPathParameter(event,"id")
            console.log('>>>> eventId:' + eventId)
            if (eventId === undefined) {
                console.log(JSON.stringify(events,null,2))
                context.succeed(util.createResponse(200, events))   // all events
            } else {
                // single event
                var found = events.filter(e =>{
                            console.log("e.id:" + e.id + " eventId:" + eventId)
                            return e.id == eventId
                } )
                if (found.length === 0) {
                    context.fail(util.createResponse(404, { error: eventId + " not found" }))
                }else{
                    context.succeed(util.createResponse(200,found[0]))
                }
            }
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
} 