'use strict'

var dev = false
process.env.dev = false
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
var lastProgram
var programs = []
var data = fs.readFileSync(__dirname + '/data.txt', 'utf8')
data.split('\r\n').forEach(line => {
    //console.log('----------------')
    if (line.startsWith('#program')) {   // program
        var parts = line.split('|')
        if (parts.length < 7) {
            throw Error(line + " does not contain all the information expected : 7 but found:" + parts.length)
        }
        //console.log(parts[2])
        var program = {
            name: parts[1],
            choreographer: parts[2],
            programtime: parts[3],
            greenroomtime: parts[4],
            reporttime: parts[5],
            duration: parts[6],
            participants: []
        }
        lastProgram = program
        programs.push(lastProgram)
    } else {
        // participants
        if (line.trim().length > 0) {
            var participant = {
                name: line.trim()
            }

            lastProgram.participants.push(participant)
        }
    }
    //console.log(line)
})

//console.log(JSON.stringify(programs, null, 2))

evt.addEventAsync(tableNames.event, '2017 GPTA Ugadi')
    .then(newEvent => {
        programs.forEach(program => {
            console.log(program.name)
            evt.addProgramAsync(tableNames.program, newEvent.id, program)
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
