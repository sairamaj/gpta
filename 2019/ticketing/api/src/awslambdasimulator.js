process.env.dev = true
var express = require('express')
var bodyParser = require('body-parser')
var app = express()
var getTickets = require('./getTickets').handler
var checkIn = require('./checkIn').handler
var addTicket = require('./addTicket').handler
var getCheckIns = require('./getCheckIns').handler
var getTicketsSummary = require('./getTicketsSummary').handler
var deleteAllTickets = require('./deleteAllTickets').handler

app.use(bodyParser.urlencoded({ extended: false }))

function getContext(res) {
    var context = {}

    context.succeed = function (data) {
        //res.send(data)
        res.json(JSON.parse(data.body))
    }
    context.fail = function (data) {
        //res.send(data)
        //var response = JSON.parse(data.body)
        console.log(`fail : ${data.status}`)
        res.status(data.statusCode)
        .send({
              message: data.body
              });
    }
    return context
}

function createCheckInEvent(id, body) {
    var event = {
        pathParameters: {
            id: ""
        }
    }

    event.pathParameters.id = id
    event.body = JSON.stringify({ "id":body.id, "adults": body.adults, "kids": body.kids, "updatedat": Date()})
    console.log(event)
    console.log(JSON.stringify(event, null, 2))
    return event
}

function createTicketsEvent(id, body) {
    console.log('createTicketsEvent')
    var event = {
        pathParameters: {
            id: ""
        }
    }

    event.pathParameters.id = id
    event.body = JSON.stringify(body)
    console.log('===================================')
    console.log(event.body)
    console.log('===================================')
    console.log(JSON.stringify(event, null, 2))
    return event
}

app.get('/tickets', function (req, res) {
    process.env.TABLE_NAME = "Ticket"
    getTickets(null, getContext(res), null)
});

app.get('/tickets/summary', function (req, res) {
    process.env.TABLE_NAME = "Ticket"
    process.env.TABLETICKETCHECKIN = "TicketCheckIn"
    getTicketsSummary(null, getContext(res), null)
});

app.post('/tickets', function (req, res) {
    console.log('in /tickets')
    process.env.TABLE_NAME = "Ticket"
    console.log(req.path)
    console.log(req.body)
    console.log(`content type:${JSON.stringify(req.headers)}`)
    var realBody = JSON.parse(Object.keys(req.body)[0])
    console.log(`realbody : ${JSON.stringify(realBody)}`)
    var e = createTicketsEvent(req.params.id, realBody)
    addTicket(e, getContext(res), null)
})

app.get('/tickets/checkins', function (req, res) {
    process.env.TABLETICKETCHECKIN = "TicketCheckIn"
    getCheckIns(null, getContext(res), null)
})

app.post('/tickets/checkins', function (req, res) {
    console.log('in /tickets/checkins')
    process.env.TABLETICKETCHECKIN = "TicketCheckIn"
    console.log(req.path)
    var realBody = JSON.parse(Object.keys(req.body)[0])
        
    var e = createCheckInEvent(req.params.id, realBody)
    checkIn(e, getContext(res), null)
})

app.delete('/tickets', function(req,res){
    console.log(`delete`)
    process.env.TABLE_NAME = "Ticket"
    deleteAllTickets(null, getContext(res), null)
});

console.log('listening 4000...')
app.listen(4000);
