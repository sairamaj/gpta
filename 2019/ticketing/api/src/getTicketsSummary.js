"use strict";
var util = require("./util");
var Promise = require("bluebird");
var evt = Promise.promisifyAll(require("./ticket"));

exports.handler = async function(event, context, callback) {
  const tableName = process.env.TABLE_NAME;
  const checkedInTableName = process.env.TABLETICKETCHECKIN;
  console.log("table name:" + tableName);
  console.log("checkedInTableName table name:" + checkedInTableName);
  var tickets = await evt.getTicketsAsync(tableName);
  var checkedIn = await evt.getCheckInsAsync(checkedInTableName);

  var adultsCount = tickets.reduce((accum, t) => accum + (t.adults === undefined ? 0 : +t.adults), 0);
  var kidsCount = tickets.reduce((accum, t) => accum + (t.kids === undefined ? 0: +t.kids), 0);
  var checkedInAdults = checkedIn.reduce((accum, t) => accum + (t.adults === undefined ? 0: +t.adults), 0);
  var checkedInKids = checkedIn.reduce((accum, t) => accum + (t.kids === undefined ? 0 : +t.kids), 0);
  context.succeed(
    util.createResponse(200, {
      adults: adultsCount,
      kids: kidsCount,
      checkedInAdults: checkedInAdults === undefined ? 0 : checkedInAdults,
      checkedInKids: checkedInKids === undefined ? 0 : checkedInKids
    })
  );
};
