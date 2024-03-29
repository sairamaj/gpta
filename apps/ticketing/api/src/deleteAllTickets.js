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
      console.log(`deleteAllTickets: Tickets:${tickets.length}`);
      if (tickets.length == 0) {
        context.succeed(
          util.createResponse(200, {
            succeeded: 0,
            failed: 0
          })
        );
        return;
      }
      var response = {};
      var succeeded = 0;
      var failed = 0;
      var totalTickets = tickets.length;
      tickets.forEach(t => {
        console.log(`deleting ${t.id}`);
        evt
          .deleteTicketAsync(tableName, t.id, t.name)
          .then(msg => {
            console.log("delete suceeded");
            succeeded++;
            if (succeeded + failed >= totalTickets) {
              context.succeed(
                util.createResponse(200, {
                  succeeded: succeeded,
                  failed: failed
                })
              );
            }
          })
          .catch(err => {
            console.error(`delete failed: ${err}`);
            failed++;
            if (succeeded + failed >= totalTickets) {
              context.succeed(
                util.createResponse(200, {
                  succeeded: succeeded,
                  failed: failed
                })
              );
            }
          });
      });
    })
    .catch(err => {
      console.log(err);
      context.fail(util.createResponse(500, err));
    });
};
