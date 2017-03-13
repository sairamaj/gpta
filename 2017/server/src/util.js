function createResponse (statusCode, body) {
  return {
    'statusCode': statusCode,
    'headers': {},
    'body': JSON.stringify(body)
  }
};

module.exports.createResponse = createResponse

