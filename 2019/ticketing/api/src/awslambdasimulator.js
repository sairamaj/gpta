process.env.dev = true
var express = require('express')
var bodyParser = require('body-parser')
var app = express()
var getTickets = require('./getTickets').handler
var checkIn = require('./checkIn').handler
var getCheckIns = require('./getCheckIns').handler

app.use(bodyParser.urlencoded({ extended: false }))

function getContext(res) {
    var context = {}

    context.succeed = function (data) {
        //res.send(data)
        res.json(JSON.parse(data.body))
    }
    context.fail = function (data) {
        //res.send(data)
        res.json(data)
    }
    return context
}

function createEvent(id, body) {
    var event = {
        pathParameters: {
            id: ""
        }
    }

    event.pathParameters.id = id
    console.log('before filling updateat.')
    event.body = JSON.stringify({ id:"abc", "adults": "1", "kids": "2", "updatedat": Date()})
    console.log(event)
    console.log(JSON.stringify(event, null, 2))
    return event
}

app.get('/tickets', function (req, res) {
    process.env.TABLE_NAME = "Ticket"
    getTickets(null, getContext(res), null)
})

app.get('/tickets/checkins', function (req, res) {
    process.env.TABLETICKETCHECKIN = "TicketCheckIn"
    getCheckIns(null, getContext(res), null)
})

app.post('/tickets/checkins', function (req, res) {
    console.log('in /tickets/checkins')
    process.env.TABLETICKETCHECKIN = "TicketCheckIn"
    console.log(req.path)
    console.log("param id:" + req.body)
    var e = createEvent(req.params.id, req.body)
    checkIn(e, getContext(res), null)
})


console.log('listening 4000...')
app.listen(4000);