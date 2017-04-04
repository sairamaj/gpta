'use strict'

var dev = true
process.env.dev = true
if (process.argv.length > 2) {
    console.log('setting dev')
    if (process.argv[2] === 'aws') {
        process.env.dev = false
        dev = false
    }
}
//process.env.dev = false
var Promise = require('bluebird')
var ticket = Promise.promisifyAll(require('./ticket'))
var fs = require('fs');
var tableNames = require('./tablenames')(dev)
var colors = require('colors')
var debug = require('debug')

//console.log(tableNames)
var lastProgram
var programs = []
var data = fs.readFileSync(__dirname + '../../UgadiTickets.csv', 'utf8')

let adultCountIndex = 0
let kidCountIndex = 1
let nameIndex = 5
let confirmationIndex = 14

data.split('\r\n').slice(2).forEach(line => {
    var parts = line.split(',')
    if (parts.length > confirmationIndex) {
        /*console.log(parts[adultCountIndex])
        console.log(parts[kidCountIndex])
        console.log(parts[nameIndex])
        console.log(parts[confirmationIndex])
        console.log('-------------------')*/

        var ticketInfo = {
            id: parts[confirmationIndex],
            name: parts[nameIndex],
            adults: parts[adultCountIndex],
            kids: parts[kidCountIndex]
        }

        if (ticketInfo.name.length == 0) {
            var msg = 'Error: >>>>  invalid ticketInfo <<<:' + JSON.stringify(ticketInfo)
            console.log(msg.red)
        } else {
            debug('adding :' + ticketInfo.name + ":" + ticketInfo.id)
            ticket.addTicketAsync(tableNames.ticket, ticketInfo)
                .then(status => {

                })
                .catch(err => {
                    console.log(err.red)
                    process.exit(-2)
                })

        }
    }
})

