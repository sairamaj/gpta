process.env.dev = true
var express = require('express')
var bodyParser = require('body-parser')
var app = express()
var getTickets = require('./getTickets').handler

app.use(bodyParser.urlencoded({ extended: false }))

function getContext(res) {
    var context = {}

    context.succeed = function (data) {
        res.send(data)
    }
    context.fail = function (data) {sd
        res.send(data)
    }
    return context
}

app.get('/tickets', function (req, res) {
    process.env.TABLE_NAME = "Ticket"
    getTickets(null, getContext(res), null)
})


console.log('listening 4000...')
app.listen(4000);