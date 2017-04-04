'use strict'
var util = require('./util')
var Promise = require('bluebird')
var evt = Promise.promisifyAll(require('./event'))

exports.handler = function (event, context, callback) {
    const tableName = process.env.TABLE_NAME
    const participantsTable = process.env.TABLE_PARTICIPANTS
    console.log('table name:' + tableName)
    var programId = util.getPathParameter(event, "id")
    console.log('getProgramParticipants ->' + programId)
    evt.getProgramParticipantsAsync(tableName, programId)
        .then(participants => {
            evt.getParticipantsAsync(participantsTable, participants)
                .then(participantsInfo => {
                    context.succeed(util.createResponse(200, participantsInfo))
                })
        })
        .catch(err => {
            console.log(err)
            context.fail(util.createResponse(500, err))
        })
} 