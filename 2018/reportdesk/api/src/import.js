'use strict'

var dev = true
process.env.dev = true
if (process.argv.length > 2) {
    console.log('setting dev')
    if (process.argv[2] === 'aws') {
        process.env.dev = false
        dev = false
    }
}
//process.env.dev = false
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))
var yaml = require('js-yaml');
var fs = require('fs');
var tableNames = require('./tablenames')(dev)


console.log(tableNames)
var programs
try {
    programs = yaml.safeLoad(fs.readFileSync(__dirname + '/data.yaml', 'utf8'));
} catch (e) {
    console.log(e);
}

evt.addEventAsync(tableNames.event, '2017 GPTA Ugadi')
    .then(newEvent => {
        programs.forEach(program => {
            console.log(program.name)
            evt.addProgramAsync(tableNames.program, newEvent.id, program.name)
                .then(programDb => {
                    program.participants.forEach(participant => {
                        console.log('     ' + participant.name)
                        evt.addParticipantAsync(tableNames.participant, participant.name)
                            .then(participantDb => {
                                evt.addParticipantToProgramAsync(tableNames.programParticipant, participantDb.id, programDb.id)
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

