process.env.dev = true
var express = require('express')
var app = express()
var getEvents = require('./getEvents').handler
var getPrograms = require('./getPrograms').handler
var getProgramParticipants = require('./getProgramParticipants').handler
var ddParticipantArrivalInfo  = require('./addParticipantArrivalInfo').handler
var getEventProgramsWithDetails = require('./getEventProgramsWithDetails').handler

function getContext(res) {
    var context = {}

    context.succeed = function (data) {
        res.send(data)
    }
    context.fail = function (data) {
        res.send(data)
    }
    return context
}

function createEvent(id, status) {
    var event = {
        pathParameters: {
            id: "",
            status: status
        }
    }

    event.pathParameters.id = id
    console.log(event)
    console.log(JSON.stringify(event, null, 2))
    return event
}

app.get('/events', function (req, res) {
    process.env.TABLE_NAME = "Event"
    getEvents(null, getContext(res), null)
})

app.get('/events/:id', function (req, res) {
    process.env.TABLE_NAME = "Event"
    console.log('=========================')
    console.log(req.path)
    console.log("param id:" + req.params.id)
    var e = createEvent(req.params.id)
    console.log(JSON.stringify(e, null, 2))
    getEvents(e, getContext(res), null)
})

app.get('/events/:id/programs', function (req, res) {
    process.env.TABLE_NAME = "Program"
    console.log('=========================')
    console.log(req.path)
    console.log("param id:" + req.params.id)
    var e = createEvent(req.params.id)
    console.log(JSON.stringify(e, null, 2))
    getPrograms(e, getContext(res), null)
})

app.get('/events/:id/programwithdetails', function (req, res) {
    process.env.TABLE_NAME_PROGRAM = "Program"
    process.env.TABLE_NAME_PARTICIPANTS = "Participant"
    process.env.TABLE_NAME_PROGRAMPARTICIPANTS = "ProgramParticipants"

    console.log('=========================')
    console.log(req.path)
    console.log("param id:" + req.params.id)
    var e = createEvent(req.params.id)
    console.log(JSON.stringify(e, null, 2))
    getEventProgramsWithDetails(e, getContext(res), null)
})

app.get('/programs/:id/participants', function (req, res) {
    process.env.TABLE_NAME = "ProgramParticipants"
    process.env.TABLE_PARTICIPANTS = 'Participant'
    console.log('===========/programs/:id/participants ==============')
    console.log(req.path)
    console.log("param id:" + req.params.id)
    var e = createEvent(req.params.id)
    console.log(JSON.stringify(e, null, 2))
    getProgramParticipants(e, getContext(res), null)
})

app.post('/participants/:id/arrivalinfo/:status', function(req,res){
    process.env.TABLE_NAME = "ParticipantArrivalInfo"
    console.log(req.path)
    console.log("param id:" + req.params.id)
    console.log("param status:" + req.params.status)
    var e = createEvent(req.params.id, req.params.status)
    ddParticipantArrivalInfo( e, getContext(res),null)
})

console.log('listening 4000...')
app.listen(4000);