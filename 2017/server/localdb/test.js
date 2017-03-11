'use strict'
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

evt.addEventAsync('Event', '2017 GPTA Ugadi')
    .then(newEvent => {
        // add a program
        console.log('event added :' + JSON.stringify(newEvent))
        evt.addProgramAsync('Program', evt.id, 'Program1')
            .then(prog => {
                console.log('program added:' + JSON.stringify(prog))
            })
            .catch(err=>{
                console.log("adding program err:" + err)
            })
    })
    .catch(err => console.log("err:" + err))