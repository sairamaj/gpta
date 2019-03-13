rem docker run -p 8000:8000 amazon/dynamodb-local
rem docker run -v "c:\\temp":/dynamodb_local_db -p 8000:8000 cnadiminti/dynamodb-local:latest
rem docker run -p 8000:8000 cnadiminti/dynamodb-local:latest
aws dynamodb create-table --table-name myTable --attribute-definitions AttributeName=id,AttributeType=S --key-schema AttributeName=id,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --endpoint-url http://0.0.0.0:8000
