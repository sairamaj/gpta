# create hash
    $ticket1 = @{ id = "1111"; name="test1 user";adults="5" ; kids="1"}
    $ticket2 = @{ id = "2222"; name="test2 user";adults="6" ; kids="1"}
    $tickets = @()
    $tickets +=  $ticket1
    $tickets += $ticket2
    
    $url  ='https://c6hqh0tjcl.execute-api.us-west-2.amazonaws.com/Prod/tickets'
    
    ($tickets | ConvertTo-Json)
    Invoke-WebRequest $url -Method Post -Body ($tickets | ConvertTo-Json)

    # using parameter splatting.
    #$parameaters = @{Uri=$url, Method='post'}
    #Invoke-WebRequest @parameaters
    
   