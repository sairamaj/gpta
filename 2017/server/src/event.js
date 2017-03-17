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
  console.log("add progam event id:" + eventId)
  var data = {
    'eventId': eventId,
    'name': name,
    'id': uuidV4()
  }
  console.log('adding program ==>' + JSON.stringify(data, null, 2))
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

function addParticipantToProgram(tableName, participantId, programId, callback) {
  var data = {
    'id': participantId,
    'programId': programId
  }

  aws.writeDb(tableName, data, function (err, status) {
    callback(err, data)
  })
}

function getPrograms(tableName, eventId, callback) {
  aws.readDb(tableName, function (err, data) {
    if (err) {
      callback(err, null)
    } else {
      var events = []
      data.Items.forEach(function (program) {
        if (program.eventId == eventId) {
          events.push(program)
        }
      })
      callback(null, events)
    }
  })
}

function getParticipants(tableName, pids, callback) {
  aws.readDb(tableName, function (err, data) {
    if (err) {
      callback(err, null)
    } else {
      var events = []
      data.Items.forEach(function (participant) {
        if (pids.find( p=> p.id === participant.id)) {
            events.push(participant)
        }
      })
      callback(null, events)
    }
  })
}

function getProgramParticipants(tableName, programId, callback) {
  aws.readDb(tableName, function (err, data) {
    if (err) {
      callback(err, null)
    } else {
      var events = []
      data.Items.forEach(function (programParticipant) {
        if (programParticipant.programId == programId) {  // todo: use query here.
          events.push(programParticipant)
        }
      })
      callback(null, events)
    }
  })
}


module.exports.addEvent = addEvent
module.exports.getEvents = getEvents
module.exports.addProgram = addProgram
module.exports.addParticipant = addParticipant
module.exports.addParticipantToProgram = addParticipantToProgram
module.exports.getPrograms = getPrograms
module.exports.getProgramParticipants = getProgramParticipants
module.exports.getParticipants = getParticipants