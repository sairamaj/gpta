'use strict'
var evt = require('./event')

evt.getEvents('Event', function (err, result) {
    if (err) {
        console.log(err)
    } else {
        console.log( JSON.stringify(result))
    }
})