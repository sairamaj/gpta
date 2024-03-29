'use strict'

var dev = false
process.env.dev = dev
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
var data = fs.readFileSync(__dirname + '\\..\\deploydata\\data.txt', 'utf8')
data.split('\r\n').forEach(line => {
    //console.log('----------------')
    if (line.startsWith('#program')) {   // program
        var parts = line.split('|')
        if (parts.length < 8) {
            throw Error(line + " does not contain all the information expected : 8 but found:" + parts.length)
        }
        //console.log(parts[2])
        var program = {
            name: parts[1],
            sequence: parts[2],
            choreographer: parts[3],
            programtime: parts[4],
            greenroomtime: parts[5],
            reporttime: parts[6],
            duration: parts[7],
            participants: []
        }
        lastProgram = program
        programs.push(lastProgram)
    } else {
        // participants
        if (line.trim().length > 0) {
            var participant = {
                name: line.trim().replace('\t',' ')
            }

            lastProgram.participants.push(participant)
        }
    }
    //console.log(line)
})

console.log(JSON.stringify(programs, null, 2))

evt.addEventAsync(tableNames.event, '2023 GPTA Ugadi')
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
