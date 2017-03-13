/*
    All mom restaraunt functionalities.
*/
var aws = require('./awsFunc')
const uuidV4 = require('uuid/v4');

function getEvents(tableName, callback) {
  aws.readDb(tableName, function (err, data) {
    if (err) {
      callback(err, null)
    } else {
      var events = []
      data.Items.forEach(function (event) {
        events.push(event)
      })
      callback(null, events)
    }
  })
}

function addEvent(tableName, name, callback) {
  var data = {
    'name': name,
    'id': uuidV4()
  }

  aws.writeDb(tableName, data, function (err, status) {
    callback(err, data)
  })
}

function addProgram(tableName, eventId, name, callback) {
  var data = {
    'eventid': eventId,
    'name': name,
    'id': uuidV4()
  }

  aws.writeDb(tableName, data, function (err, status) {
    callback(err, data)
  })
}

function addParticipant(tableName, name, callback) {
  var data = {
    'name': name,
    'id': uuidV4()
  }

  aws.writeDb(tableName, data, function (err, status) {
    callback(err, data)
  })
}

function addParticipantToProgram(tableName, participantId, programId, callback){
  var data = {
    'participantId': participantId,
    'programId': programId
  }

  aws.writeDb(tableName, data, function (err, status) {
    callback(err, data)
  })
}

module.exports.addEvent = addEvent
module.exports.getEvents = getEvents
module.exports.addProgram = addProgram
module.exports.addParticipant = addParticipant
module.exports.addParticipantToProgram = addParticipantToProgram
