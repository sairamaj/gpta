# create hash
    $ticket1 = @{ id = "1111"; name="test1 user";adults="2" ; kids="1"}
    $ticket2 = @{ id = "2222"; name="test2 user";adults="3" ; kids="1"}
    $tickets = @()
    $tickets +=  $ticket1
    $tickets += $ticket2
    
    $url = "http://localhost:4000/tickets"
    
    ($tickets | ConvertTo-Json)
    Invoke-WebRequest $url -Method Post -Body ($tickets | ConvertTo-Json) -ContentType "application/x-www-form-urlencoded" 

    # using parameter splatting.
    #$parameaters = @{Uri=$url, Method='post'}
    #Invoke-WebRequest @parameaters
    
   