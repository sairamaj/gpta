var express = require('express')
var app = express()
var getEvents = require('./getEvents').handler

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

function createEvent(id) {
    var event = {
        pathParameters: {
            id:""
        }
    }

    event.pathParameters.id = id
    console.log(event)
    console.log(JSON.stringify(event, null, 2))
    return event
}

app.get('/events', function (req, res) {
    getEvents(null, getContext(res), null)
})

app.get('/events/:id', function (req, res) {
    console.log('=========================')
    console.log(req.path)
    console.log("param id:" + req.params.id)
    var e = createEvent(req.params.id)
    console.log(JSON.stringify(e, null, 2))
    getEvents(e, getContext(res), null)
})


console.log('listening 3000...')
app.listen(3000);