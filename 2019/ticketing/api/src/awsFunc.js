/*
    All aws related functionalities
*/
'use strict'
var AWS = require('aws-sdk')
AWS.config.update({
  region: 'us-west-2'
 // endpoint: "http://localhost:8000"
})

console.log('dev:' + process.env.dev)
if( process.env !== undefined && process.env.dev == 'true'){
  console.log('setting endpoint...')
  AWS.config.endpoint = 'http://127.0.0.1:8000'
}

var sns = new AWS.SNS()

function readDb(table, callback) {
  var docClient = new AWS.DynamoDB.DocumentClient()
  var params = {
    TableName: table
  }

  docClient.scan(params, onScan)
  function onScan(err, data) {
    if (err) {
      callback(err, null)
    } else {
      callback(null, data)
    }
  }
}

function writeDb(table, data, callback) {
    console.log(`writeDb ${AWS.config.endpoint}`)
  var docClient = new AWS.DynamoDB.DocumentClient()

  var params = {
    TableName: table,
    Item: data
  }

  docClient.put(params, callback)
}

function deleteDb(table, key, callback) {
  var docClient = new AWS.DynamoDB.DocumentClient()
  var params = {
    TableName: table,
    Key: key
  }

  docClient.delete(params, callback)
}

function queryDb(table, params, callback) {
  var docClient = new AWS.DynamoDB.DocumentClient()
  docClient.query(params, callback)
}

function sendNotification(data, topicArn, callback) {
  var payload = {
    default: data,
    APNS: {
      aps: {
        alert: data,
        sound: 'default',
        badge: 1
      }
    }
  }


  // first have to stringify the inner APNS object...
  payload.APNS = JSON.stringify(payload.APNS)
  // then have to stringify the entire message payload
  payload = JSON.stringify(payload)

  sns.publish({
    Message: payload,
    MessageStructure: 'json',
    TopicArn: topicArn
  }, callback)
}

function sendMenuItemAddedNotification(menuItem) {
  sendNotification(menuItem + ' has been added', 'arn:aws:sns:us-west-2:034046765900:kidapp', function (err, response) {
    if (err) {
      console.log('error sending notification:' + err)
    } else {
      console.log('successfully sent notifications.')
    }
  })
}

function sendMenuItemRemovedNotification(menuItem) {
  sendNotification(menuItem + ' has been removed', 'arn:aws:sns:us-west-2:034046765900:kidapp', function (err, response) {
    if (err) {
      console.log('error sending notification:' + err)
    } else {
      console.log('successfully sent notifications.')
    }
  })
}

function sendOrderNotification(menuItem) {
  sendNotification(menuItem + ' has been ordered', 'arn:aws:sns:us-west-2:034046765900:MomRestarant', function (err, response) {
    if (err) {
      console.log('error sending notification:' + err)
    } else {
      console.log('successfully sent notifications.')
    }
  })
}

module.exports.readDb = readDb
module.exports.writeDb = writeDb
module.exports.deleteDb = deleteDb
module.exports.queryDb = queryDb
module.exports.sendMenuItemAddedNotification = sendMenuItemAddedNotification
module.exports.sendMenuItemRemovedNotification = sendMenuItemRemovedNotification
module.exports.sendOrderNotification = sendOrderNotification

