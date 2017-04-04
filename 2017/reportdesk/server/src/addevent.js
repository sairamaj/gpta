'use strict'
var evt = require('./event')

evt.addEvent('Event', '2017 GPTA Ugadi', function (err, result) {
    if (err) {
        console.log(err)
    } else {
        console.log('added' + result)
    }
})