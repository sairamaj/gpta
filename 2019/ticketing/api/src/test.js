var x = {"{\"id\": \"3EA582744A199533T\" , \"adults\": \"1\" ,\"kids\": \"1\" ,\"updatedAt\": \"2019-03-17 01:27:40  0000\" }":""}
console.log(x)
var y = JSON.parse( Object.keys(x)[0] )
console.log(y.id)
