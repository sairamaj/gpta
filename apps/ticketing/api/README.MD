# Overview

This subdirectory contains source for ticket app for creating API.

## How to deploy

Lets say we are going to do for 2023 year function.

- Create S3 bucket

```cmd
    aws s3 mb s3://gpta2023
```

- Create package for deployment
  - Update the package.bat for year.
    aws cloudformation package --template-file app_spec.yaml --output-template-file new_app_spec.yaml --s3-bucket **gpta2023**
    run package.bat at command prompt
    `cmd
    package.bat
    `
- Run deployment
  - Update year in deploy.bat
    aws cloudformation deploy --template-file new_app_spec.yaml --stack-name **gpta2023-ticketing** --capabilities CAPABILITY_IAM --parameter-overrides Stage=prod
  ```cmd
  deploy.bat
  ```
  - This may take a while as it is creating all AWS resources (API gateway, Lamba and Dynamo db)

## Validate

How to validate the deployment

### Validating the API

* Log on to aws console
* Go to API Gateway
* Select gpta2023-ticketing API
* Go to staging , select PROD and copy the Invoke URL on right side pane:
* Open powershell command
* Run the following command (Replace the URL you have copied from aws console)

```powershell
  Invoke-RestMethod https://j142kxxeal.execute-api.us-west-2.amazonaws.com/Prod/tickets
```
* At this time basic GET is working and looks like we have basic setup.

* Lets test other apis

- You should see below response
    ```cmd
    StatusCode        : 200
    StatusDescription : OK
    Content           : []
    RawContent        : HTTP/1.1 200 OK
                        Connection: keep-alive
                        Date: Sat, 18 Mar 2023 18:42:06 GMT
                        x-amzn-RequestId: a74f138c-e663-444b-9bfc-43a0ae918541
                        x-amz-apigw-id: B_XfqFLrvHcF0IA=
                        X-Amzn-Trace-Id: Root=1-641605fd…
    Headers           : {[Connection, System.String[]], [Date, System.String[]], [x-amzn-RequestId, System.String[]],
                        [x-amz-apigw-id, System.String[]]…}
    Images            : {}
    InputFields       : {}
    Links             : {}
    RawContentLength  : 2
    RelationLink      : {}
    ```
