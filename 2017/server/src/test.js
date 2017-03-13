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
                // add participants
                evt.addParticipantAsync('Participant','sai')
                .then( p=>{
                    // adding participant to program
                     evt.addParticipantToProgramAsync("ParticipantToProgram", p.id, prog.id)
                     .then( ptoP => console.log("successfully added participant to program"))
                     .catch(err => console.log("err in assigning a participan to program." + err))
                })
                .catch(err => console.log("err in adding a participant:" + err))

            })
            .catch(err=>{
                console.log("adding program err:" + err)
            })
    })
    .catch(err => console.log("err:" + err))