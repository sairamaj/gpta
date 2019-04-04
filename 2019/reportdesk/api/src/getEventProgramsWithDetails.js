'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

exports.handler = function (event, context, callback) {
    var programTableName = process.env.TABLE_NAME_PROGRAM
    var participantsTableName = process.env.TABLE_NAME_PARTICIPANTS
    var programToParticipantsTableName = process.env.TABLE_NAME_PROGRAMPARTICIPANTS
    console.log('table name:' + programTableName)
    var eventId = util.getPathParameter(event, "id")
    console.log('getPrograms ->' + eventId)

    Array.prototype.first = function () {
        return this[0];
    };

    evt.getProgramsAsync(programTableName, eventId)
        .then(programs => {
            evt.getAllParticipantsAsync(participantsTableName)
                .then(participants => {
                    evt.getAllProgramParticipantsAsync(programToParticipantsTableName)
                        .then(programParticipants => {


                            var programsWithDetails = []
                            programs.forEach(p => {
                                
                                console.log('-------------------')
                                console.log(programParticipants)
                                console.log('-------------------')

                                var programDetail = {}
                                programDetail.name = p.name
                                programDetail.id = p.id
                                programDetail.sequence = p.sequence
                                programDetail.choreographer = p.choreographer
                                programDetail.duration = p.duration
                                programDetail.greenroomtime = p.greenroomtime
                                programDetail.programtime = p.programtime
                                programDetail.reporttime = p.reporttime

                                programDetail.participants = programParticipants.filter(pp => pp.programId === p.id)
                                programDetail.participants = programDetail.participants.map( pp =>{
                                    var p = participants.filter( pt1 => pt1.id == pp.id).first()
                                    return {
                                        name : p.name,
                                        id: p.id
                                    }
                                    
                                })
                                
                                // programDetail.participants = participants.filter(pd=>{
                                //     pd.id = 
                                // })

                                console.log('______________')
                                console.log(programDetail)
                                console.log('_____________')
                                //programDetail.pp2 = participants
                                programsWithDetails.push(programDetail)
                            })
                            context.succeed(util.createResponse(200, programsWithDetails))
                        })
                        .catch(err => {
                            console.log(err)
                            context.fail(util.createResponse(500, err))
                        })
                })
                .catch(err => {
                    console.log(err)
                    context.fail(util.createResponse(500, err))
                })
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
} 