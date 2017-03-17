'use strict'
process.env.dev = true
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))
var yaml = require('js-yaml');
var fs = require('fs');

var programs
try {
    programs = yaml.safeLoad(fs.readFileSync(__dirname + '/data.yaml', 'utf8'));
} catch (e) {
    console.log(e);
}

evt.addEventAsync('Event', '2017 GPTA Ugadi')
    .then(newEvent => {
        programs.forEach(program => {
            console.log(program.name)
            evt.addProgramAsync('Program', newEvent.id, program.name)
                .then(programDb => {
                    program.participants.forEach(participant => {
                        console.log('     ' + participant.name)
                        evt.addParticipantAsync('Participant', participant.name)
                            .then(participantDb => {
                                evt.addParticipantToProgramAsync("ProgramParticipants", participantDb.id, programDb.id)
                                    .catch(err => {
                                        console.log(err)
                                        process.exit(-4)
                                    })
                            })
                            .catch(err => {
                                console.log(err)
                                process.exit(-3)
                            })
                    })
                })
                .catch(err => {
                    console.log(err)
                    process.exit(-2)
                })
        })
    })
    .catch(err => {
        console.log(err)
        process.exit(-1)
    })

