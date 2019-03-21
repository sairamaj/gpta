"use strict";
var util = require("./util");
var Promise = require("bluebird");
var evt = Promise.promisifyAll(require("./ticket"));

exports.handler = function(event, context, callback) {
  const tableName = process.env.TABLE_NAME;
  console.log("table name:" + tableName);
  evt
    .getTicketsAsync(tableName)
    .then(tickets => {
      tickets.forEach(t => {
        console.log(`deleting ${t.id}`);
        evt
          .deleteTicketAsync(tableName, t.id, t.name)
          .then(msg => {
            console.log("delete suceeded");
          })
          .catch(err => {
            console.error(`delete failed: ${err}`);
          });
      });
      // todo: need to capture items failed.
      context.succeed(util.createResponse(200, {}));
    })
    .catch(err => {
      console.log(err);
      context.fail(util.createResponse(500, err));
    });
};
