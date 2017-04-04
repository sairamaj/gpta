function createResponse (statusCode, body) {
  return {
    'statusCode': statusCode,
    'headers': {},
    'body': JSON.stringify(body)
  }
};

function getPathParameter(o, name) {
    console.log("getPathParameter:" + o)
    if (o === null) {
        return
    }
    console.log("getPathParameter:" + o.pathParameters)
    if (o.pathParameters === undefined) {
        return
    }

    console.log("getPathParameter2:" + o.pathParameters)
    if (o.pathParameters === null) {
        return
    }
    console.log("getPathParameter3:" + o.pathParameters)
    if(o.pathParameters[name] === undefined){
        return
    }
    console.log(JSON.stringify(o.pathParameters,null,2))
    return o.pathParameters[name]
}

module.exports.createResponse = createResponse
module.exports.getPathParameter = getPathParameter
