'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

function getPathParameter(o, name) {
    console.log("getPathParameter:" + o)
    if (o === null) {
        return
    }
    console.log("getPathParameter:" + o.pathParameters)
    if (o.pathParameters === undefined) {
        return
    }

    console.log("getPathParameter2:" + o.pathParameters)
    if (o.pathParameters === null) {
        return
    }
    console.log("getPathParameter3:" + o.pathParameters)
    if(o.pathParameters[name] === undefined){
        return
    }
    console.log(JSON.stringify(o.pathParameters,null,2))
    return o.pathParameters[name]
}

exports.handler = function (event, context, callback) {

    evt.getEventsAsync('Event')
        .then(events => {
            var eventId = getPathParameter(event,"id")
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