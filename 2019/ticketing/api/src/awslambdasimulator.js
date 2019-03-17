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
        //var response = JSON.parse(data.body)
        console.log(`fail : ${data.status}`)
        res.status(data.statusCode)
        .send({
              message: data.body
              });
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
    event.body = JSON.stringify({ "id":body.id, "adults": body.adults, "kids": body.kids, "updatedat": Date()})
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
    var realBody = JSON.parse(Object.keys(req.body)[0])
        
    var e = createEvent(req.params.id, realBody)
    checkIn(e, getContext(res), null)
})


console.log('listening 4000...')
app.listen(4000);
