aws dynamodb create-table --table-name Event --attribute-definitions AttributeName=id,AttributeType=S AttributeName=name,AttributeType=S --key-schema AttributeName=id,KeyType=HASH AttributeName=name,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --endpoint-url http://localhost:8000

aws dynamodb create-table --table-name Program --attribute-definitions AttributeName=id,AttributeType=S AttributeName=eventId,AttributeType=S --key-schema AttributeName=id,KeyType=HASH AttributeName=eventId,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --endpoint-url http://localhost:8000

aws dynamodb create-table --table-name Participant --attribute-definitions AttributeName=id,AttributeType=S AttributeName=name,AttributeType=S --key-schema AttributeName=id,KeyType=HASH AttributeName=name,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --endpoint-url http://localhost:8000

aws dynamodb create-table --table-name ProgramParticipants --attribute-definitions AttributeName=id,AttributeType=S AttributeName=programId,AttributeType=S --key-schema AttributeName=id,KeyType=HASH AttributeName=programId,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --endpoint-url http://localhost:8000

aws dynamodb create-table --table-name ParticipantArrivalInfo --attribute-definitions AttributeName=id,AttributeType=S AttributeName=isArrived,AttributeType=N --key-schema AttributeName=id,KeyType=HASH AttributeName=isArrived,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 --endpoint-url http://localhost:8000
